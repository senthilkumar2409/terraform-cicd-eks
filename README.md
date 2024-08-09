![image](https://github.com/user-attachments/assets/10a22226-d628-4236-bc18-f5daec7459f5)
<h1> Automating the EKS cluster creation using Jenkins and Terraform</h1>

In today's fast-paced DevOps environment, automation is the key to efficiency and reliability. Creating and managing Kubernetes clusters, such as Amazon EKS (Elastic Kubernetes Service), can be a complex and time-consuming task if done manually. By leveraging Jenkins and Terraform, you can automate the entire process of EKS cluster creation, ensuring consistency, reducing human error, and saving valuable time. streamlining your EKS cluster creation process to mere clicks or commands instead of hours spent on manual configurations.

we’ll see the seamless integration of Jenkins and Terraform to automate the EKS cluster setup—from initial configuration to deployment—empowering.

<h2>Pre-requistes</h2>

**Jenkins Installation** -  Setup a Jenkins server by installing Jenkins on EC2 instance.  

**Terraform Installation** - Install Terraform on the Jenkins server.

**AWS CLI Installation** - Install the AWS Command Line Interface (CLI) and configure it with your AWS credentials (or) Attach the IAM role on Jenkins server to access the aws cloud

## Terraform Configuration File structure

```
terraform-cicd-eks/
├── modules/
│   ├──vpc
├   └── main.tf └──
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── manifest/
    ├── deployment.yaml
    └── service.yaml
```


