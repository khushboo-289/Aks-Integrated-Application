pipeline {
    agent any

    environment {
        ACR_NAME = 'khushacr989397'
        AZURE_CREDENTIALS_ID = 'azure-aks-service-principal'
        ACR_LOGIN_SERVER = "${ACR_NAME}.azurecr.io"
        IMAGE_NAME = 'dotnet-webapi'
        IMAGE_TAG = 'latest'
        RESOURCE_GROUP = 'rg-integrated-aks'
        AKS_CLUSTER = 'aksweb1221'
        TF_WORKING_DIR = 'terraform44'
    }

    stages {
        stage('Checkout') {
            steps {
               git branch: 'master', url: 'https://github.com/khushboo-289/Aks-Integrated-Application.git'
            }
        }

        stage('Build .NET App') {
            steps {
                bat 'dotnet publish AksProject/AksProject.csproj -c Release -o out'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %ACR_LOGIN_SERVER%/%IMAGE_NAME%:%IMAGE_TAG% -f AksProject/Dockerfile ."
            }
        }

       stage('Terraform Init') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    bat """
                    echo "Navigating to Terraform Directory: %TF_WORKING_DIR%"
                    cd %TF_WORKING_DIR%
                    echo "Initializing Terraform..."
                    terraform init
                    """

                }
            }
        }

        stage('Terraform Plan') {
    steps {
        withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
            bat """
            echo "Navigating to Terraform Directory: %TF_WORKING_DIR%"
            cd %TF_WORKING_DIR%
            terraform plan -out=tfplan
            """

        }
    }
}


        stage('Terraform Apply') {
    steps {
        withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
            bat """
            echo "Navigating to Terraform Directory: %TF_WORKING_DIR%"
            cd %TF_WORKING_DIR%
            echo "Applying Terraform Plan..."
            terraform apply -auto-approve tfplan
            """

        }
    }
}
        stage('Login to ACR') {
            steps {
                bat "az acr login --name %ACR_NAME%"
            }
        }

        stage('Push Docker Image to ACR') {
            steps {
                bat "docker push %ACR_LOGIN_SERVER%/%IMAGE_NAME%:%IMAGE_TAG%"
            }
        }

        stage('Get AKS Credentials') {
            steps {
                bat "az aks get-credentials --resource-group %RESOURCE_GROUP% --name %AKS_CLUSTER% --overwrite-existing"
            }
        }

        stage('Deploy to AKS') {
            steps {
                bat "kubectl apply -f AksProject/deployment.yaml"
            }
        }
    }

    post {
        success {
            echo 'All stages completed successfully!'
        }
        failure {
            echo 'Build failed.'
        }
    }
}

 

