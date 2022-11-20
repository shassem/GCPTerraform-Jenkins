
# GCP with Terraform and Jenkins (ITI Final Project Part One)

Creating infrastructure and deployment process using Terraform (IaC) to implement and configue secure Google Container Cluster (GKE) on Google Cloud Platform (GCP) to host Jenkins as Kubernetes pods.

I used a private VM Instance to connect to an all-private GKE Cluster. 
![image](https://drive.google.com/uc?export=view&id=19IdhZiowP98DnYK5cSMZLW69o9iuBGcb)

### Project Part Two: A fully automated CI/CD pipeline using Jenkins to build and deploy an application whenever it gets updated on GitHub <br />
The Application URL --> https://github.com/shassem/ITI-FinalProject-Jenkins 

## Illustrations
### Tools
- Terraform
- Google Cloud Platform (GCP)
- Jenkins

Each tool implementations are written in its section.

All work is applied on a single GCP project and region: us-central1. <br />
Variables can be changed.

### Terraform & GCP
Backend bucket to store the state file as an object that can be accessed by the users working on the same project.

Network module that setups VPC Network with two subnets and the rest necessary configurations as shown below:
- Management subnet (Instance) / Cluster subnet (Cluster)
- NAT service for the private instance/cluster
- Firewall that allows SSH and HTTP

Private VM Instance with a service account that has Kubernetes Cluster Admin permission attached with the Management subnet so I can use it to manage the cluster GKE. <br />
Adding a start-up script that installs:
- Docker --> to build/push images.
- kubectl --> to apply kubernetes commands on the cluster.
- gcloud authentication plugin --> to extend kubectl’s authentication to support GKE.

Standard Google Container Cluster service with private control plane and working nodes. Letting the VM instance the only authorized instance to connect to the cluster. 

### Jenkins
In order to let Jenkins connect to the cluster, I have to give the app the required credentials and use the gcloud command.
So I created a Dockerfile with the jenkins image and added gcloud installation commands. Then I built the image and pushed it to Dockerhub so I can pull it from the deployment file.

Dockerhub jenkins image repository: https://hub.docker.com/repository/docker/shassem/jenkinsgcp 

Deployment file:
- Created a new namespace called "jenkins" for the jenkins app.
- Init Containers to install docker and kubernetes and mounting the binary files so I can use docker cli and kubectl in the pipeline.
- Mounting the docker.sock path so I can execute docker commands inside the application and to let the container deploy another containers on GKE.
- Mounting jenkins_home to save all the configurations and details done in the jenkins app.
- Load balancer that listens on port 8080.

You may get encountered by an error when you open the jenkins app for the first time:
"HTTP ERROR 403 No valid crumb was included in the request". <br />
![Error 403](https://drive.google.com/uc?export=view&id=1uWzmRerXLqJxICcoFgz8crOIz2tvUiYd) <br />
or a reverse proxy broken message:<br />
![Error ReverseProxy](https://drive.google.com/uc?export=view&id=1LGGJkqUiE73AnajJGQ0pSYnS8O6SAM5N) <br />
This error may prevent the app to function properly. In order to fix this issue: <br />
Skip admin creation (optional: if you are stuck) --> Enter "Manage Jenkins" --> "Configure Global Security" --> "Enable proxy compatibility". <br />
![Enable proxy compatibility](https://drive.google.com/uc?export=view&id=1ZZWJvp1twjt4oktYUnDxfk8VjucAAWY_) <br />
Reference: https://stackoverflow.com/questions/44711696/jenkins-403-no-valid-crumb-was-included-in-the-request <br /> 

Credentials Configurations:
- Create a credential for your Dockerhub account.
- Secret file credentials that contains the VM service account key pair file in order to have access to the cluster.


## Setup
### Commands

#### Creating resources with Terraform

```bash
    cd Terraform
    terraform init                     #initializes a working directory and installs plugins for google provider
    terraform plan                     #to check the changes
    terraform apply -auto-approve      #creating the resources on GCP
```
#### The VM Startup Script

Installing kubectl: 
```bash
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```
Installing dockercli
```bash
    apt-get update -y && apt-get install ca-certificates curl gnupg lsb-release -y && mkdir -p /etc/apt/keyrings

    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt-get update -y && apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
```
Installing the gcloud authentication plugin
```bash
    apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
```

Installation References:
- https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
- https://docs.docker.com/engine/install/ubuntu/
- https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke

#### SSH into the VM instance
From the GUI --> ssh to the instance and then connect to the cluster
```bash
    gcloud container clusters get-credentials {cluster-id} --region {region} --project {project-id}
```
cluster-id = my-gke-cluster <br />
region = us-central1 <br />
project = neat-talent-367811

#### Building the Dockerfile for jenkins and pushing to Dockerhub
Create the Dockerfile: <br />
Then:
```bash
    docker build -t shassem/jenkinsgcp
    docker login
    docker push shassem/jenkinsgcp
```
#### Deploying the jenkins app
Create the deployment.yml file <br />
```bash
    kubectl apply -f deployment.yml
```
Checking on the pods and getting the load balancer external IP
```bash
    kubectl get all -n jenkins
```
Get the Administrator Jenkins password from the pod logs
```bash
    kubectl logs pod/{podname} -n jenkins
```

### Now you are ready to use Jenkins on a GKE cluster!🚀

#### Connected Repository:

CI/CD using Jenkins --> https://github.com/shassem/ITI-FinalProject-Jenkins 
