# Install_K8s
At this point, I do not have a favored or even successful method.  I am starting to collect a bunch of links 
to different method/approach.

## Kubeadm
NOTE: kubeadm apparently requires you to set SELinux to permissive mode.

Firstly, install kubeadm
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

Then Create your cluster
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

## MicroK8s
https://microk8s.io/

On all nodes (apparently with a slight delay between each execution)
```
sudo snap install microk8s --classic
````

On the "primary"
```
sudo su -
microk8s status --wait-ready
microk8s kubectl get nodes
microk8s add-node

while true; do  SLEEPYTIME=5; echo "CRTL-C to stop checking"; microk8s kubectl get nodes; echo; while [ $SLEEPYTIME -gt 0 ]; do echo -ne "Check again in:  $SLEEPYTIME\033[0K\r"; sleep 1; : $((SLEEPYTIME--)); done;  done
```

On all the "non-primary" nodes
```
microk8s join {URL from above}
```

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
