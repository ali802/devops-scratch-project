pipeline {
    agent {
        docker {
            // A certified public devops image containing fully functioning bash, git, and terraform
            image 'alpine/terragrunt:tk-1.5-tf-1.5'
        }
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }

    stages {
        stage('Terraform Init & Plan') {
            steps {
                sh 'terraform init -reconfigure'
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Ansible Deploy Note') {
            steps {
                echo "Infrastructure deployed successfully via clean Docker automation!"
            }
        }
    }
}
