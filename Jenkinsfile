pipeline {
    agent any

    environment {
        DEV_AWS_ACCOUNT = "43582935235"
        TERRAFORM_APPLY = "YES"
        TERRAFORM_DESTROY = "NO"
    }
    // when {
    //     branch 'DEV'
    // }
    stages {
        stage('terraform initialization') {
            steps {
                sh 'terraform init'
          }
        }    
        stage('terraform plan') {
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
