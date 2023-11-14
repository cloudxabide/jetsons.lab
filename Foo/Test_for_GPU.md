# test for GPU

Run this ON your NVIDIA Jetson (I used my Xavier to test this)
This is working - 2023-11-14
```
cd /usr/local/cuda/samples/1_Utilities/deviceQuery
sudo make
mkdir -p ~/Notebooks/deviceQuery
cp deviceQuery $_
sudo docker run -it --rm --runtime nvidia --network host -v /home/nvidia/Notebooks:/Notebooks nvcr.io/nvidia/l4t-ml:r34.1.0-py3 Notebooks/deviceQuery/deviceQuery
```

Sort of unbelievable how difficult this was to figure out.  I would have assume a container already existed that had the deviceQuery binary.
