pipeline {
    agent {
        docker {
            // Using the official, ultra-lightweight Terraform image (No heavy OS layer)
            image 'hashicorp/terraform:1.5.7'
            args '-u root --entrypoint='
        }
    }

    stages {
        stage('Terraform Init & Plan') {
            steps {
                echo 'Initializing using lightweight container agent...'
                // Using the native Jenkins vault wrapper to firmly bind keys to the shell environment
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
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
}
