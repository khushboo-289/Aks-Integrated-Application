pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS_ID = 'azure-aks-service-principal' // Jenkins credentials ID (Service Principal)
        RESOURCE_GROUP = 'rg-integrated-aks' 
        ACR_NAME = 'khushacr989397'
        ACR_LOGIN_SERVER = "${ACR_NAME}.azurecr.io"
        IMAGE_NAME = 'dotnet-webapi'
        AKS_CLUSTER = 'aksweb1221'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/khushboo-289/Aks-Integrated-Application.git'
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    bat 'az login --service-principal -u %AZURE_CLIENT_ID% -p %AZURE_CLIENT_SECRET% --tenant %AZURE_TENANT_ID%'
                    bat 'cd terraform44 && terraform init'
                    bat 'cd terraform44 && terraform plan'
                    bat 'cd terraform44 && terraform apply -auto-approve'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %ACR_LOGIN_SERVER%/%IMAGE_NAME%:latest .'
            }
        }

        stage('Push Docker Image to ACR') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    bat 'az login --service-principal -u %AZURE_CLIENT_ID% -p %AZURE_CLIENT_SECRET% --tenant %AZURE_TENANT_ID%'
                    bat 'az acr login --name %ACR_NAME%'
                    bat 'docker push %ACR_LOGIN_SERVER%/%IMAGE_NAME%:latest'
                }
            }
        }

        stage('Deploy to AKS') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    bat 'az login --service-principal -u %AZURE_CLIENT_ID% -p %AZURE_CLIENT_SECRET% --tenant %AZURE_TENANT_ID%'
                    bat 'az aks get-credentials --resource-group %RESOURCE_GROUP% --name %AKS_CLUSTER%'
                    bat 'kubectl apply -f k8s\\deployment.yaml'
                }
            }
        }
    }

    post {
        success {
            echo '✅ Deployment to AKS Successful!'
        }
        failure {
            echo '❌ Deployment Failed!'
        }
    }
}

