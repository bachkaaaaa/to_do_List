pipeline {
    agent any
    environment {
        SSH_KEY = credentials('ssh') // Replace with your Jenkins credential ID for Secret Text

        DOCKER_IMAGE = "bachka512/todo-list-app" // Replace with your Docker image name
    }
  stages{ 
        stage('Checkout') {
            steps {
                // Pulls the specified branch from the repository
                git branch: "main", url: 'https://github.com/bachkaaaaa/to_do_List',credentialsId:'Github-credentials'
            }
        }
         

         
        

        stage('infra Terraform') {
    steps {
        withAWS(credentials: 'Aws-credentials') {
            script {
                sh '''
		    cd terraform
                    terraform init
                    terraform apply -auto-approve
                '''

                // Capture the RDS endpoint directly from the terraform output command
                env.RDS_ENDPOINT = sh(script: 'terraform output -raw db_endpoint', returnStdout: true).trim()
                                         env.INSTANCE_IP = sh(script: 'terraform output -raw public_ip', returnStdout: true).trim()

                echo "RDS Endpoint is: ${RDS_ENDPOINT}"
            }
        }
    }
}

        stage('Update application.yml with RDS Endpoint') {
            steps {
                script {
                    sh'pwd'
                                        sh'ls'

                    // Simplified sed command to replace the database URL in application.yml
                    sh """
                        sed -i 's|url:.*|url: jdbc:postgresql://${RDS_ENDPOINT}/mydb|' src/main/resources/application.yaml
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh "sudo docker build . -t ${DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
         
                                  sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"

                        sh "docker push ${DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                    }
                }
            }
        }


stage('Prepare Inventory') {
            steps {
                // Write the SSH key to a file
                writeFile file: 'ssh_key', text: "${SSH_KEY}"
                // Set the correct permissions for the SSH key file
                sh 'chmod 600 ssh_key'
                                sh 'ls -al'
                            sh'cat ssh_key'


                // Write the inventory file
script {
                    // sh """
                    // echo "[aws_instances]" > inventory.ini
                    // echo "${env.INSTANCE_IP} ansible_user=ubuntu" >> inventory.ini
                    // """
                     sh """
                    echo "[aws_instances]" > inventory.ini
                    echo "13.38.4.7 ansible_user=ubuntu" >> inventory.ini
                    """
                }

            }
        }
        stage('Deploy with Ansible') {
            steps {
                // Run the Ansible playbook using the SSH key stored in the file
sh "ansible-playbook -i inventory.ini ./ansible/docker_setup.yml --private-key=/home/bachka/.ssh/id_rsa"
            }
        }
    }
    post {
        always {
            // Clean up the SSH key file to avoid leaving sensitive data
            sh 'rm -f ssh_key'
        }
// stage('Test Key Access') {
//             steps {
//                 script {
//                     sh 'cat /home/bachka/.ssh/id_rsa.pub'
//                 }
//             }
//         }
        
    }
}
