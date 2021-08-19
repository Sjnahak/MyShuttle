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
                    cp $WORKSPACE/target/myshuttledev.war $WORKSPACE/src
                '''
          }
        }
		
		stage("Docker image tomcat") { //Stage 1 will build POM.xml and will create binary
		    //DOCKER_REG=ip:8082/artifactory/shuttle-docker-dev/subfolder -from jenkins config
			//docker login dockerreponame.jfrog.io
            steps {
			    dir ("${WORKSPACE}/src"){
			    withDockerRegistry(credentialsId: 'jfrog', url: "${jfrog_url}") {
                sh '''
                    docker build  . -t ${DOCKER_REG}/tomcat:${BUILD_NUMBER}
                '''
				}
				}
            }
        }
		
		stage('Docker-Push-tomcat') {
            steps {
                rtDockerPush(
					serverId: 'artifactory',
					image: "${DOCKER_REG}/tomcat:${BUILD_NUMBER}",
					targetRepo: 'shuttle-docker-dev/',
					buildName: "dev-shuttle",
                    buildNumber: "${BUILD_NUMBER}",
                )
                
            }
        }
		
		stage("Docker image database") { //Stage 1 will build POM.xml and will create binary
            steps {
			    dir ("${WORKSPACE}/src/db"){
			    withDockerRegistry(credentialsId: 'jfrog', url: "${jfrog_url}") {
                sh '''
                    docker build  . -t ${DOCKER_REG}/db:${BUILD_NUMBER}
                '''
				}
				}
            }
        }
		
		stage('Docker-Push-db') {
            steps {
                rtDockerPush(
					serverId: 'artifactory',
					image: "${DOCKER_REG}/db:${BUILD_NUMBER}",
					targetRepo: 'shuttle-docker-dev/',
					buildName: "dev-shuttle",
                    buildNumber: "${BUILD_NUMBER}",
                )
                
            }
        }
		
	}
    
}
