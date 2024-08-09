pipeline {
    agent any

    stages {
        stage('terraform initialization') {
            steps {
            withCredentials([gitUsernamePassword(credentialsId: 'git_cred', gitToolName: 'Default')]) {
                sh 'terraform init'
            }  
          }
        }    
        stage('terraform plan') {
            steps {
                sh 'terraform plan -var-file="vpc_ec2.tfvars"'
            }
        }
        stage('terraform deploy') {
            steps {
                sh 'terraform destroy -var-file="vpc_ec2.tfvars" -auto-approve'
            }
        }
    }
}

