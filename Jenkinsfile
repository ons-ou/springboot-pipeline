pipeline {
    agent any

    tools {
      maven 'M2_HOME'
      jdk 'JAVA_HOME'
    }
    stages {

        stage('Clone Repo GIT') {
            steps {
                git branch: 'main',
                url : 'https://github.com/ons-ou/springboot-pipeline';
            }
        }

        stage('Mvn Scripts') {
            steps {
                echo 'cleaning project ...'
                sh 'mvn clean'

                echo 'artifact construction ...'
                sh 'mvn package -Dmaven.test.skip=true -P test-coverage'

                echo 'compiling project ...'
                sh 'mvn compile'
            }
        }

        stage('Maven junit tests'){
            steps{
                sh 'mvn test -Dtest=SecteurActivTest -DfailIfNoTests=false'
                sh 'mvn test -Dtest=ProduitServiceImplTestImpl -DfailIfNoTests=false'
            }
        }

        stage('Docker Compose Sonar Nexus') {
             steps {
                sh 'docker-compose -f docker-compose-sonar-nexus.yml up -d'
             }
        }

        
        stage('Mvn SonarQube') {
            steps {
            	sh """ mvn sonar:sonar -Dsonar.projectKey=springboot-devops -Dsonar.host.url=http://192.168.1.17:9000 -Dsonar.login="fb8367ec875e9b7a808667884843110d6f0c2f78" """;
            }
        }

        
        stage('Nexus Script') {
            steps {
                script {
                	sh """ mvn deploy:deploy-file -DgroupId=com.esprit.examen -DartifactId=tpAchatProject -Dversion=1.0 -DgeneratePom=true -Dpackaging=jar -DrepositoryId=deploymentRepo -Durl=http://192.168.1.17:8081/repository/springboot-pipeline/ -Dfile=target/tpAchatProject-1.0.jar """
                }
            }
        }
        
        stage('Clean install') {
             steps {
                sh 'mvn clean package -DskipTests'
             }
        }

        stage('Docker build Image') {
            steps {
                sh 'docker build -t kaiswch/springboot-pipeline .'
            }
        }

        /*
        stage('Docker push to Dockerhub') {
            steps {
                sh """ docker login -u kaiswch -p dckr_pat_c-YI66AiVg-Tq2KksBZWqezaOyg """
                sh """ cat ~/.docker/config.json """
                sh """ docker push kaiswch/springboot-pipeline """
            }
        }*/
        

        stage('Docker compose up') {
             steps {
                sh 'docker-compose up -d'
             }
        }
        
        
    }
    post {
        always {
             echo 'Pipeline finished'
         }
    }
}