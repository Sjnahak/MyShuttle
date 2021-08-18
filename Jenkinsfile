pipeline {
    agent { node { label 'debian' } }
    tools {
        maven 'maven' //maven configuration setup in Jenkins global configuration
    }
    
    stages {
        stage("Maven Build") { //Stage 1 will build POM.xml and will create binary
            when {
                expression { params.ENVIRONMENT == 'main' }
            }
            steps {
                sh '''
                    mvn clean verify -DskipTests -Dbuildnum=${BUILD_NUMBER}
                '''
          }
        }
        
		
        
    }
    
}
