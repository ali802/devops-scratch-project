pipeline {
    agent {
        docker {
            // Native, lightweight Terraform image
            image 'hashicorp/terraform:1.5.7'
            args '-u root --entrypoint='
        }
    }

    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }

    stages {
        stage('Terraform Init & Plan') {
            steps {
                echo 'Initializing infrastructure...'
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh 'terraform init -reconfigure'
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                echo 'Applying infrastructure changes...'
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Ansible Deploy') {
            steps {
                echo 'Setting up Ansible and deploying configuration...'
                // Install Ansible and OpenSSH utilities dynamically into the lightweight container
                sh 'apk add --no-cache ansible openssh-client'

                // Securely extract your SSH Private Key to authenticate with your EC2 instances
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY_PATH')]) {
                    sh """
                        # Dynamically inject the temporary secure key path into your inventory file
                        sed -i "s|ansible_ssh_private_key_file=[^ ]*|ansible_ssh_private_key_file=${SSH_KEY_PATH}|g" inventory.ini
                        
                        # Execute the playbook deployment
                        ansible-playbook -i inventory.ini playbook.yml
                    """
                }
            }
        }
    }
}
