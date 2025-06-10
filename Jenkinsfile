pipeline {
    agent any

    environment {
        DEV_AWS_ACCOUNT = "435829351243"
        TERRAFORM_APPLY = "YES"
        TERRAFORM_DESTROY = "NO"
    }
    stages {
        stage('terraform initialization') {
            when {
             expression {
                 "${env.TERRAFORM_APPLY}" == "YES"
                }
            }
            steps {
                sh 'terraform init'
          }
        }    
        stage('terraform plan') {
            when {
             expression {
                 "${env.TERRAFORM_APPLY}" == "YES"
                }
            }
            steps {
                sh 'terraform validate'
                sh 'terraform plan -var-file="vpc_ec2.tfvars"'
            }
        }
        stage('terraform apply') {
            when {
             expression {
                 "${env.TERRAFORM_APPLY}" == "YES"
                }
            }
            steps {
                sh 'terraform apply -var-file="vpc_ec2.tfvars" -auto-approve'
            }
        }
        stage('terraform destroy') {
            when { 
                expression {
                    "${env.TERRAFORM_DESTROY}" == "YES"
                }
            }
            steps {
                sh 'terraform destroy -var-file=vpc_ec2.tfvars -auto-approve'
            }
        }
    }
}
