pipeline {
    agent {
        docker {
            // Using a lightweight, pre-configured DevOps image containing Terraform, Ansible, and AWS CLI
            image 'msnh/infra-tools:latest'
            // Giving the container access to the host's Docker socket if needed
            args '-v /var/run/docker.sock:/var/run/docker.sock'
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
                sh 'terraform init'
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
