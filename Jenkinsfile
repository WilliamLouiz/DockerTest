pipeline {
    agent any

    environment {
        REGISTRY = 'solofonore/html'
        DOCKER_IMAGE = "${REGISTRY}:version-${env.BUILD_ID}"
        VERSION_FILE = 'version.txt'
        DEFAULT_VERSION = '1'
        VERSION_NUMBER = ''
    }

    stages {
        stage('Clonage du dépôt') {
            steps {
                script {
                    // Supprimer le répertoire existant avant de cloner à nouveau le dépôt
                    sh 'rm -rf DockerTest'
                    // Cloner le dépôt dans le répertoire spécifié
                    sh 'git clone https://github.com/WilliamLouiz/DockerTest.git DockerTest'
                    // Aller dans le répertoire cloné
                    dir('DockerTest') {
                        // Vérifier le contenu du répertoire
                        sh 'ls -la'
                    }
                }
            }
        }

        stage('Récupération de la version') {
            steps {
                script {
                    // Aller dans le répertoire cloné
                    dir('DockerTest') {
                        // Vérifier si le fichier de version existe
                        if (fileExists(VERSION_FILE)) {
                            // Lire la version à partir du fichier
                            VERSION_NUMBER = readFile(VERSION_FILE).trim()
                        } else {
                            // Utiliser la version par défaut si le fichier n'existe pas
                            VERSION_NUMBER = DEFAULT_VERSION
                        }
                    }
                }
            }
        }

        stage('Construction de l\'image Docker') {
            steps {
                script {
                    // Aller dans le répertoire cloné
                    dir('DockerTest') {
                        // Construire l'image Docker avec la version spécifiée
                        sh "docker build -t ${DOCKER_IMAGE} ."
                    }
                    // Se connecter au registre Docker
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        // Pousser l'image Docker vers le registre
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Cleanup Artifacts') {
            steps {
                script {
                    // Supprimer l'image Docker locale
                    sh "docker rmi ${DOCKER_IMAGE}"
                    // Arrêter et supprimer le conteneur Docker
                    sh "docker stop web || true"
                    sh "docker rm web || true"
                    // Démarrer un nouveau conteneur avec l'image mise à jour
                    sh "docker run -d -t -p 8082:80 --name web ${DOCKER_IMAGE}"
                }
            }
        }
    }
}
