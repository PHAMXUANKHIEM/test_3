pipeline {
    agent any

    environment {
        APP_NAME = "test_3"
        DOCKER_REPO = "khiemvip7e/${APP_NAME}"
        DOCKER_CREDENTIALS = "docker-hub-credentials"
    }

    stages {
        stage('Clone Code') {
            steps {
                git branch: 'main',
                    url: 'git@github.com:PHAMXUANKHIEM/test_3',
                    credentialsId: 'github-ssh'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_REPO}:${BUILD_NUMBER} ."
            }
        }

        stage('Test Docker Image') {
            steps {
                sh """
                    docker run --rm -d --name ${APP_NAME}-test -p 8080:80 ${DOCKER_REPO}:${BUILD_NUMBER}
                    sleep 5
                    curl -f http://localhost:8080 || exit 1
                    docker stop ${APP_NAME}-test
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS}", 
                                                 usernameVariable: "DOCKER_USER", 
                                                 passwordVariable: "DOCKER_PASS")]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_REPO}:${BUILD_NUMBER}
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                sh """
                    docker stop ${APP_NAME} || true
                    docker rm ${APP_NAME} || true
                    docker run -d --name ${APP_NAME} -p 80:80 ${DOCKER_REPO}:${BUILD_NUMBER}
                """
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished!'
        }
    }
}

