pipeline {
  agent any
    
  environment {
  registry = "Hajer-DR/employees-client"

  }
    
  stages {

    
    stage('EMPLOYEE-CLIENT - CI') {
            environment {
                registryCredential = 'dockerhub'
            }
            steps{
                script {
                 
				    git 'https://github.com/Hajer-DR/employee-client.git'
                    def appimage = docker.build registry + ":$BUILD_NUMBER"
                    docker.withRegistry( '', registryCredential ) {
                        appimage.push()
                        appimage.push('latest')
                    }
                }
            } 
 } 
 
 
    
 
         stage('DEPLOY TO PREPROD'){
            steps {
                withAWS(region:'us-east-2',credentials:'aws-creds') {
				  git url:'https://github.com/Narjesse/devOpsaws.git', branch:'main'
                    sh 'aws eks --region us-east-2 update-kubeconfig --name my-eks'   
                    sh 'kubectl create namespace preprod --dry-run -o yaml | kubectl apply -f - '
                    sh 'kubectl delete -f deployment-CLI-POD.yml --namespace=preprod'
                    sh 'kubectl apply -f deployment-CLI-All.yml --namespace=preprod'
                }
            }
        }
		
		
		         stage('DEPLOY TO PROD'){
            steps {
                withAWS(region:'us-east-2',credentials:'aws-creds') {
				  git url:'https://github.com/Narjesse/devOpsaws.git', branch:'main'
                    sh 'aws eks --region us-east-2 update-kubeconfig --name my-eks'   
                    sh 'kubectl create namespace prod --dry-run -o yaml | kubectl apply -f - '
                    sh 'kubectl delete -f deployment-CLI-POD.yml --namespace=prod'
                    sh 'kubectl apply -f deployment-CLI-All.yml --namespace=prod'
                }
            }
        }
        

 }
 
}
