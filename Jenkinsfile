pipeline {
    agent { 
        node {
            label "macOS"
        }
    }
    
    stages {
        stage('Clone Repo') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [[$class: 'CleanBeforeCheckout', deleteUntrackedNestedRepositories: true]], userRemoteConfigs: [[url: 'https://github.com/stretch327/SOS-MacOSSaveOpenDialog.git/']]])
            }
        }
    }
}
