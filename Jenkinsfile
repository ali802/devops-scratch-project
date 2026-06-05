pipeline {
    agent {
        docker {
            // Using the official, guaranteed public ultra-lightweight Alpine image
            image 'alpine:3.20'
        }
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }

    stages {
        stage('Setup Tools Inside Container') {
            steps {
                echo 'Installing infrastructure tools inside the pristine container environment...'
                // apk is the official package manager for Alpine - fast, lightweight, and rock solid
                sh 'apk add --no-cache terraform ansible openssh-client git'
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
