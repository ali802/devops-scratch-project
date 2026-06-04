pipeline {
    agent any

    // NEW: Injecting your AWS credentials so Jenkins can log in
    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
    }

    stages {
        // NEW: Our first automation milestone
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
    }
}
