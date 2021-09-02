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
            steps {
                dir ("${WORKSPACE}/src"){
                withDockerRegistry(credentialsId: 'azurecr', url: "${azurecr_url}") {
                    sh '''
                    docker build  . -t ${DOCKER_REG}/tomcat:tomcat-${BUILD_NUMBER}
					docker push ${DOCKER_REG}/tomcat:tomcat-${BUILD_NUMBER}
                    '''
                }
                }
            }
        }

        stage("Docker image database") { //Stage 1 will build POM.xml and will create binary
            steps {
                dir ("${WORKSPACE}/src/db"){
                    withDockerRegistry(credentialsId: 'azurecr', url: "${azurecr_url}") {
                        sh '''
                            docker build  . -t ${DOCKER_REG}/db:db-${BUILD_NUMBER}
                            docker push ${DOCKER_REG}/db:db-${BUILD_NUMBER}
                        '''
                    }
                }
            }
        }
        
        stage('Deploy web-tier') {
            steps {
                script {
		            kubernetesDeploy(kubeconfigId: 'mykubeconfig',
                        configs: 'web-deploy.yaml',
                        enableConfigSubstitution: true,
                    )
		        }
            }
        }
		
		stage('Deploy DB') {
            steps {
                script {
		            kubernetesDeploy(kubeconfigId: 'mykubeconfig',
                        configs: 'db-deploy.yaml',
                        enableConfigSubstitution: true,
                    )
		        }
            }
        }
        
        stage('Selenium Test Run') {
            steps {
                sh 'sleep 10'
                sh 'mvn test'
            }
             
        }

    }
    post {
        always {
            junit 'target/surefire-reports/junitreports/*.xml' 
            step( [ $class: 'JacocoPublisher' ] )
            step([$class: 'Publisher', reportFilenamePattern: '**/testng-results.xml'])
        }
    }
}
