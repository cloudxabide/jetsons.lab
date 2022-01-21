# Deploy k3s on Xavier

## Docker on the Xavier

Install k3s using https://www.suse.com/c/ai-at-the-edge-with-k3s-nvidia-jetson-nano-object-detection-real-time-video-analytics-src/

```
sudo apt update sudo apt upgrade -y sudo apt install curl
case `lshw | awk -F\: '{ print $2 }' | grep "NVIDIA Jetson` in
  "NVIDIA Jetson Xavier NX Developer Kit")
    sudo nvpmodel -m 8
  ;;
  *)
    echo "Yup"
  ;;
esac

sudo su -
curl -sfL https://get.k3s.io/ | INSTALL_K3S_EXEC="--docker" sh -s –

# I tested this is necessary.  Docker CUDA works, but k3s did not (without this update)
cat << EOF > /etc/docker/daemon.json
{
	 "default-runtime": "nvidia",

	 "runtimes": {

		 "nvidia": {
			  "path": "nvidia-container-runtime", "runtimeArgs": []

		 }
	 }

}
EOF
systemctl restart docker
sudo docker info | grep Runtime
```

## Update Docker for Jetson SDK
https://github.com/dusty-nv/jetson-containers/issues/108
```
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update
sudo apt-get install nvidia-docker2=2.8.0-1
```

## Run DeviceQuery (2 methods)
### DeviceQuery Docker
```
cat << EOF > Dockerfile.deviceQuery
FROM nvcr.io/nvidia/l4t-base:r32.5.0
RUN apt-get update && apt-get install -y --no-install-recommends make g++
COPY ./samples /tmp/samples
WORKDIR /tmp/samples/1_Utilities/deviceQuery
RUN make clean && make
CMD ["./deviceQuery"]
EOF

cp -R /usr/local/cuda/samples .
 
docker build -t xift/jetson_devicequery:r32.5.0 . -f Dockerfile.deviceQuery
docker run --rm --runtime nvidia xift/jetson_devicequery:r32.5.0
[output...]
./deviceQuery Starting...

 CUDA Device Query (Runtime API) version (CUDART static linking)

Detected 1 CUDA Capable device(s)

Device 0: "Xavier"
  CUDA Driver Version / Runtime Version          10.2 / 10.2
  CUDA Capability Major/Minor version number:    7.2
  Total amount of global memory:                 7765 MBytes (8142626816 bytes)
  ( 6) Multiprocessors, ( 64) CUDA Cores/MP:     384 CUDA Cores
  GPU Max Clock rate:                            1109 MHz (1.11 GHz)
  Memory Clock rate:                             1109 Mhz
  Memory Bus Width:                              256-bit
  L2 Cache Size:                                 524288 bytes
  Maximum Texture Dimension Size (x,y,z)         1D=(131072), 2D=(131072, 65536), 3D=(16384, 16384, 16384)
  Maximum Layered 1D Texture Size, (num) layers  1D=(32768), 2048 layers
  Maximum Layered 2D Texture Size, (num) layers  2D=(32768, 32768), 2048 layers
  Total amount of constant memory:               65536 bytes
  Total amount of shared memory per block:       49152 bytes
  Total number of registers available per block: 65536
  Warp size:                                     32
  Maximum number of threads per multiprocessor:  2048
  Maximum number of threads per block:           1024
  Max dimension size of a thread block (x,y,z): (1024, 1024, 64)
  Max dimension size of a grid size    (x,y,z): (2147483647, 65535, 65535)
  Maximum memory pitch:                          2147483647 bytes
  Texture alignment:                             512 bytes
  Concurrent copy and kernel execution:          Yes with 1 copy engine(s)
  Run time limit on kernels:                     No
  Integrated GPU sharing Host Memory:            Yes
  Support host page-locked memory mapping:       Yes
  Alignment requirement for Surfaces:            Yes
  Device has ECC support:                        Disabled
  Device supports Unified Addressing (UVA):      Yes
  Device supports Compute Preemption:            Yes
  Supports Cooperative Kernel Launch:            Yes
  Supports MultiDevice Co-op Kernel Launch:      Yes
  Device PCI Domain ID / Bus ID / location ID:   0 / 0 / 0
  Compute Mode:
     < Default (multiple host threads can use ::cudaSetDevice() with device simultaneously) >

deviceQuery, CUDA Driver = CUDART, CUDA Driver Version = 10.2, CUDA Runtime Version = 10.2, NumDevs = 1
Result = PASS
```

### DeviceQuery (Kube)
```
kubectl run -i -t devquery --image=xift/jetson_devicequery:r32.5.0 --restart=Never
[output... truncated...]
deviceQuery, CUDA Driver = CUDART, CUDA Driver Version = 10.2, CUDA Runtime Version = 10.2, NumDevs = 1
Result = PASS
kubectl logs devquery
kubectl delete devquery
```

```
cat << EOF >  pod_deviceQuery.yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: devicequery
spec:
  containers:
    - name: nvidia
      image: xift/jetson_devicequery:r32.5.0
      command: [ "./deviceQuery" ]
EOF
KUBECONFIG=/etc/rancher/k3s/k3s.yaml kubectl apply -f ./pod_deviceQuery.yaml
kubectl logs devicequery
kubectl delete pod devicequery
```
