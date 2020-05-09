pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
		sh "ls -l"
		sh "./deploy.sh"
            }
        }
    }
}
