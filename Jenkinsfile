pipeline {
    agent any

    stages {
        stage('terraform ') {
            steps {
                git branch: 'main', credentialsId: 'git_cred', url: 'https://github.com/senthilkumar2409/terraform-cicd-eks.git'
            }
        }
        stage('terraform initialization') {
            steps {
                sh 'terraform init'
            }
        }    
        stage('terraform validation') {
            steps {
                sh 'terraform validate'
            }
        }
        stage('terraform plan') {
            steps {
                sh 'terraform plan -var-file="vpc_ec2.tfvars"'
            }
        }
        stage('terraform deploy') {
            steps {
                sh 'terraform apply -var-file="vpc_ec2.tfvars" -auto-approve'
            }
        }
    }
}

