pipeline {
    agent {
        docker {
            // Using the official, lightweight image
            image 'hashicorp/terraform:1.5.7'
            args '-u root --entrypoint='
        }
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
                echo 'Setting up Ansible environment...'
                sh 'apk add --no-cache ansible openssh-client'

                // Everything is wrapped together so Terraform can hit the S3 backend and Ansible can use the SSH key
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY'),
                    sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY_PATH')
                ]) {
                    script {
                        echo "Querying secure S3 backend for the new server IP..."
                        NEW_IP = sh(script: "terraform output -raw target_server_public_ip", returnStdout: true).trim()
                        echo "Fetched brand new EC2 IP from Terraform: ${NEW_IP}"
                    }

                    sh """
                        # Re-write the inventory file from scratch with the dynamic IP and key path
                        echo "[webservers]" > inventory.ini
                        echo "${NEW_IP} ansible_user=ubuntu ansible_ssh_private_key_file=${SSH_KEY_PATH}" >> inventory.ini
                        
                        echo "--- Current Dynamic Inventory Configuration ---"
                        cat inventory.ini
                        echo "------------------------------------------------"

                        # Execute the playbook deployment using the fresh host address
                        ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook.yml
                    """
                }
            }
        }
    }
}
