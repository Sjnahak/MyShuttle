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
		
		stage("Copy war") { //Stage 1 will build POM.xml and will create binary
            steps {
                sh '''
                    cp $WORKSPACE/target/ $WORKSPACE/src
                '''
          }
        }
		
		stage("Docker image tomcat") { //Stage 1 will build POM.xml and will create binary
            steps {
			    withDockerRegistry(credentialsId: 'jfrog', url: "${jfrog_url}") {
                sh '''
				    
                    docker build  -f $WORKSPACE/src/Dockerfile -t ${DOCKER_REG}:${BUILD_NUMBER}"
                '''
				}
            }
        }
		
		stage('Docker-Push-tomcat') {
            steps {
                rtDockerPush(
					serverId: 'artifactory',
					image: "${DOCKER_REG}:${BUILD_NUMBER}",
					targetRepo: 'shuttle-docker-dev',
					buildName: "dev-shuttle",
                    buildNumber: "${BUILD_NUMBER}",
                )
                
            }
        }
	}
    
}
