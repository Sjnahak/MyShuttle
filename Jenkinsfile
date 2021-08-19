pipeline {
    agent { node { label 'master' } }
    tools {
        maven 'maven' //maven configuration setup in Jenkins global configuration
    }
    
    stages {
        stage("Maven Build") { //Stage 1 will build POM.xml and will create binary
            //when {
            //    expression { params.ENVIRONMENT == 'main' }
            //}
            steps {
                sh '''
                    mvn clean package -Dtest=FaresTest,SimpleTest
                '''
          }
        }
        
        stage('Static analysis') { //Stage 2 will run static analysis with SonarQube

            environment {
                scannerHome = tool 'sonar' //Defined globally in Jenkins configuration
            }
            steps {
                withSonarQubeEnv('SONARQUBE') { //defines in configure section
                    sh '''
                        ${scannerHome}/sonar-scanner -Dproject.settings=sonar-project.properties
                    '''
                }
            }
        }
		
        
    }
    
}
