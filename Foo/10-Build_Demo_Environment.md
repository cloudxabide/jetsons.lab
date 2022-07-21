# Demo - Build Environment
Status:  In Progress

* Deploy vSphere
* Deploy supporing infrastructure services
  * DNS
  * IDM
  * PXE, WWW, TFTP, DHCP
  * Network Attached Storage
* Deploy OpenShift (on vSphere Cluster)
  * OpenShift
  * OpenShift Data Foundations
  * Quay / Clair
  * Red Hat Advanced Cluster Management
  * Red Hat Advanced Cluster Security
* Deploy CI/CD services
  * Red Hat OpenShift Pipeline
  * Red Hat OpenShift GitOps
* Deploy Single Node OpenShift
* Deploy/configure NVIDIA Jetson Xavier NX (with post-install to run Jetbot training models)
* Deploy/configure NVIDIA Jetson Jetbot image
* Gather different sets of images from Jetbot
  * dataset16 - 16" from "wall" as blocked  (estimate 20 images total)
  * dataset4 - 4" from "wall" as blocked  (estimate 50 images total)
  * NOTE: the dataset that will be utilized by Notebook will always be named dataset.zip

Once the entire ecosystem is built and functional, the demo will start with the Jetbot ingesting the model from dataset16 and demonstrate how it responds to "danger" when 16" away.
