pipeline {
   agent {
		any
	}	
	
   environment {
     PROJECT = ""
     APP_NAME = ""
     FE_SVC_NAME = "${APP_NAME}-frontend"
     CLUSTER = ""
     CLUSTER_ZONE = ""
     IMAGE_TAG = "gcr.io/${PROJECT}/${APP_NAME}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"
     JENKINS_CRED = "${PROJECT}"
    }
    options {
	timestamps()
	disableConcurrentBuilds()
	buildDiscarder(logRotator(numToKeepStr: "${env.Max_builds_keep}", artifactDaysToKeepStr: "${env.artifactDaysToKeep}"))
	}
	
    stages {
        stage('Clone Repository') {
       	    steps {
		cleanWs()
		  }
	}
	stage(Build Code){
  	     steps{
		echo "Build the source code"
		 }
	}
	stage(Upload Artifact){
	     steps{
		echo "Upload the artifcat"			 }
	    	 }
        }   
	stage(Build-push-docker-img){
	     steps{
	        echo "Build the docker image and tag"
		echo "Push the docker image to docker registyr"
		 }
	}
        stage('Deploy the code') {
            steps {
                echo 'Deploying..'
	        sh "./deploy.sh"
            }
        }
    }
}
