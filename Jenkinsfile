pipeline {
    agent {
        docker {
            // Use the official HashiCorp image that ALREADY has terraform pre-installed
            image 'hashicorp/terraform:1.5.7'
            // Crucial: Combines the official image with root tracking execution powers
            args '-u root --entrypoint='
        }
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }

    stages {
        stage('Setup Additional Tools') {
            steps {
                echo 'Terraform is already natively installed! Adding ansible and git...'
                // Since this is an official hashicorp alpine base, we just add ansible and git
                sh 'apk add --no-cache ansible openssh-client git'
            }
        }

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

        stage('Ansible Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY_PATH')]) {
                    sh """
                        sed -i "s|ansible_ssh_private_key_file=[^ ]*|ansible_ssh_private_key_file=${SSH_KEY_PATH}|g" inventory.ini
                        ansible-playbook -i inventory.ini playbook.yml
                    """
                }
            }
        }
    }
}
