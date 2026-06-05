pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:1.5.7'
            args '-u root --entrypoint='
        }
    }

    stages {
        stage('Terraform Init & Plan') {
            steps {
                echo 'Securely injecting credentials directly to the execution shell...'
                // withCredentials securely decrypts the vault keys directly into memory 
                // ONLY for the duration of this block. Nothing is ever written to disk or Git.
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
