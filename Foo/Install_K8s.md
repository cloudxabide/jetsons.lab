# Install_K8s

## Kubeadm
Firstly, install kubeadm

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

Then Create your cluster

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

## Kurl
While this appears to not be ready for ARM, it's still worth a look
https://kurl.sh

If you see the following, that's a good indication you have an unsupported arch
```
root@elroy:~# curl https://kurl.sh/89e4764 | sudo bash
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  209k    0  209k    0     0   336k      0 --:--:-- --:--:-- --:--:--  336k
Package kurl-bin-utils-v2021.05.07-1.tar.gz already exists, not downloading
main: line 1051: ./bin/kurl: cannot execute binary file: Exec format error
main: line 5159: ./bin/yamltobash: cannot execute binary file: Exec format error
```
