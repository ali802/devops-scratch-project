pipeline {
    agent {
        docker {
            // Using a standard, fully-featured Ubuntu container base
            image 'ubuntu:24.04'
            args '-u root'
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
                echo 'Installing required deployment tools inside the isolated container...'
                sh '''
                    apt-get update && apt-get install -y gnupg software-properties-common curl wget git
                    
                    # Install official HashiCorp Terraform
                    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
                    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.p/hashicorp.list
                    
                    # Install Ansible
                    apt-get update && apt-get install -y terraform ansible
                '''
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
