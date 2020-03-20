pipeline {
  agent none

  stages {
    stage ('package.xml creation') { 
      agent { label 'salesforce' }
      steps {
        timestamps {
          script {
            slackSend (channel: "${slack_channel}", color: '#FFFF00', message: "STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
            try {
              sh "./sf_partial_deployment_creation.sh ${ENV:mode} \"${ENV:value}\" ${ENV:branch} ${ENV:BUILD_NUMBER}"
              sh "echo 'Contents of package.xml:' && cat ./package.xml"
            }
            catch (error) {
              echo "An Error was thrown. Exiting"
              throw error
            }
          }
          archiveArtifacts allowEmptyArchive: false, artifacts: "**/*.zip", fingerprint: true
          stash includes: "**/artifact/**, **/lib/**, **/*.zip", name: "salesforce-deploy"
        }
      }
    }

    stage ('checkpoint') {
      agent none
      steps {
        timestamps{
          checkpoint "SF Artifact creation completed"
        }
      }
    }

    stage ('ant task') {
      agent { label 'salesforce' }
      steps {
        timestamps{
          unstash "salesforce-deploy"
          dir('./lib') {
            withCredentials([[$class: 'UsernamePasswordMultiBinding', 
                                       credentialsId: "${ENV:credentials}", 
                                       passwordVariable: 'sf_password',
                                       usernameVariable: 'sf_username']]) {
              sh "sed -i -e \"s/<Insert your Salesforce username here>/${env.sf_username}/\" \
                         -e \"s/<Insert your Salesforce password here>/${env.sf_password}/\" build.properties"

              echo "Starting URL transformation test"
              script {
                if ( environment != 'production' ){
                  echo "environment is set to $environment. test.salesforce.com will not be transformed in build.properties"
                }
                else {
                  echo "environment is set to $environment. test.salesforce.com will be transformed to login.salesforce.com in build.properties"
                  sh "sed -i -e 's/test.salesforce.com/login.salesforce.com/' build.properties"
                }
               }
              echo "End of URL transformation test"

              sh "ant -verbose ${target}"
            }
          }
        }
      }
    }

    stage ('milestone') {
      agent none
      steps {
        milestone 1
      }
    }
  }


  post {
    success {
      timestamps{
        slackSend (channel: "${slack_channel}", color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
      }
    }

    failure {
      timestamps{
        slackSend (channel: "${slack_channel}", color: '#FF0000', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        emailext (
          subject: "FAILED: Job ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
          body: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]. Check console output at ${env.BUILD_URL}.",
          recipientProviders: [[$class: 'DevelopersRecipientProvider']]
        )
      }
    }
  }    
}
