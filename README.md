
# GCP with Terraform and Jenkins (ITI Final Project)

Creating infrastructure and deployment process to implement and configue secure Google Container Cluster (GKE) on Google Cloud Platform (GCP) using Terraform (IaC).

I used a private VM Instance to connect to an all-private GKE Cluster. 

## Tools
- Terraform
- Google Cloud Platform (GCP)
- Jenkins
Each tool implementations are written in its section.

All the work is applied on a single GCP project and region: us-central1.
Variables can be changed.
### Terraform & GCP
Backend bucket to store the state file as an object that can be accessed by the users working on the same project.

Network module is created that setups VPC Network with two subnets and the rest necessary configurations as shown below:
- Management subnet (Instance) / Cluster subnet (Cluster)
- NAT service
- Firewall that allows SSH and HTTP

Private VM Instance with a service account that has Kubernetes Cluster Admin permission attached with the Management subnet so I can use it to manage the cluster GKE.
Adding a start-up script that installs:
- Docker --> to build/push images.
- kubectl --> to apply kubernetes commands on the cluster.
- gcloud authentication plugin --> to extend kubectl’s authentication to support GKE.

Standard Google Container Cluster service with private control plane and working nodes, having a service account that has the Storage Admin permission. Giving the authorization to the created VM instance only.  

### Jenkins
In order to let Jenkins connect to the cluster, I have to give the app the required credentials and use the gcloud command.
So I created a Dockerfile with the jenkins image and added gcloud installation commands. Then I built the image and pushed it to Dockerhub so I can pull it from the deployment file.

Dockerhub jenkins image repository: https://hub.docker.com/repository/docker/shassem/jenkinsgcp 

Deployment file:
- Created a new namespace called "jenkins" for the jenkins app.
- Init Containers to install docker and kubernetes so I can use docker cli and kubectl in the pipeline.
- Mounting the docker.sock path so I can execute docker commands inside the application.
- Mounting jenkins_home to save all the configurations and details done in the jenkins app.
- Load balancer that listens on port 8080.

You may get encountered by an error when you open the jenkins app for the first time:
"HTTP ERROR 403 No valid crumb was included in the request".
This error may prevent the app to function properly. In order to fix this issue:
Skip admin creation (optional: if you are stuck) --> Enter "Manage Jenkins" --> "Configure Global Security" --> "Enable proxy compatibility".
Reference: https://stackoverflow.com/questions/44711696/jenkins-403-no-valid-crumb-was-included-in-the-request 

Credentials Configurations:
- Create a credential for your Dockerhub account.
- Secret file credentials that contains the VM service account key pair file in order to have access to the cluster.

### Now you are ready to use Jenkins on a GKE cluster!🚀

## Connected Repository:

CI/CD using Jenkins --> https://github.com/shassem/ITI-FinalProject-Jenkins 
