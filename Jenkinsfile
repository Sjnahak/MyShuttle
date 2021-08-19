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
        
		
        
    }
    
}
