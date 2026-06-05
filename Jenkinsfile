pipeline {
    agent {
        docker {
            // Using the official, guaranteed public ultra-lightweight Alpine image
            image 'alpine:3.20'
            // Crucial fix: Gives the container internal root powers to install tools dynamically
            args '-u root'
        }
    }

    environment {
        // Links directly to the secure credentials you saved in the Jenkins Web UI
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }

    stages {
        stage('Setup Tools Inside Container') {
            steps {
                echo 'Container now running as root. Installing infrastructure tools...'
                // Installs everything fresh and clean inside the sandbox
                sh 'apk add --no-cache terraform ansible openssh-client git'
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                // -reconfigure forces Terraform to clear any old host cache files and talk directly to S3
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
                // Safely extracts your saved SSH .pem key into a temporary environment variable path
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
