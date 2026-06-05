pipeline {
    agent {
        docker {
            // This certified image comes pre-baked with Terraform, Ansible, Git, and SSH keys utilities!
            image 'zenika/terraform-ansible:latest'
            // Keep root execution so Jenkins tracks processes smoothly inside the container environment
            args '-u root --entrypoint='
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
                echo 'Prerequisites are pre-baked! Jumping straight into deployment...'
                // Explicitly forcing variables inside the shell execution line to guarantee AWS reads them
                sh '''
                    export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
                    export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"
                    terraform init -reconfigure
                    terraform plan -out=tfplan
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                    export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
                    export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"
                    terraform apply -auto-approve tfplan
                '''
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
