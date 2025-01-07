# Automated Deployment of To-Do List Application  

This project demonstrates the **automated deployment** of a To-Do List application using **Jenkins**, **GitHub**, **Terraform**, **Docker**, **Ansible**, and **AWS**. The deployment pipeline automates the entire process, from infrastructure provisioning to application deployment on an EC2 instance.

---

## 🛠️ Features  
- **Jenkins Pipeline**: Automates the deployment process, ensuring a streamlined workflow.  
- **Infrastructure as Code (IaC)**: Terraform is used to provision AWS resources efficiently and reproducibly.  
- **Dockerized Application**: The application is containerized with Docker and pushed to Docker Hub.  
- **Configuration Management**: Ansible deploys and configures the application on an EC2 instance.  
- **Cloud Deployment**: The To-Do List application is deployed on AWS EC2 instances for scalability and reliability.

---

## 🚀 Technologies Used  
- **Jenkins**: Continuous Integration and Continuous Deployment (CI/CD).  
- **Git and GitHub**: Version control and code repository.  
- **Terraform**: Infrastructure as Code (IaC) for provisioning AWS resources.  
- **Docker**: Application containerization and image management.  
- **Ansible**: Automation of deployment and configuration.  
- **AWS**: Cloud platform for hosting the application.

---

## 🗂️ Project Structure  
```plaintext
.
├── Jenkinsfile           # CI/CD pipeline configuration
├── terraform/            # Terraform configuration files for AWS infrastructure
├── ansible/              # Ansible playbooks and roles for deployment
├── Dockerfile            # Dockerfile for building the application image
├── src/                  # Source code for the To-Do List application
├── README.md             # Documentation (this file)

