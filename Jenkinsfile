/* -*- mode: groovy -*-
  Configure how to run our job in Jenkins.
  See https://castle-engine.io/jenkins .
*/

pipeline {
  options {
    /* While concurrent builds of this work OK,
       they stuck Jenkins much with too many long-running builds.
       Better to wait for previous build to finish. */
    disableConcurrentBuilds()
  }

  /* This job works on a few agents in parallel */
  agent none

  environment {
    // See https://gitlab.com/freepascal.org/fpc/source/-/tags for posibilities
    FPC_BRANCHTAG='release_3_2_2'
    // Must match FPC version in install directory.
    FPC_VERSION='3.2.2'
  }
  stages {
    /* Build for each platform in parallel. */
    stage('Run parallel builds') {
      parallel {
        stage('Docker (Linux)') {
          agent {
            docker {
              image 'kambi/castle-engine-cloud-builds-tools:cge-none'
            }
          }
          stages {
            stage('(Docker) Cleanup') {
              steps {
                sh 'rm -Rf fpcsrc/ fpc/ fpc-*.zip'
                sh 'mkdir -p fpc/'
              }
            }
            stage('(Docker) Get FPC sources') {
              steps {
                sh 'git clone https://gitlab.com/freepascal.org/fpc/source.git --depth 1 --single-branch --branch "${FPC_BRANCHTAG}" fpcsrc'
              }
            }
            stage('(Docker) Build and install FPC') {
              steps {
                dir ('fpcsrc/') {
                  sh 'make clean all install INSTALL_PREFIX="${WORKSPACE}"/fpc'
                  sh 'make clean' // clean after build, as we'll package this fpcsrc directory
                }
              }
            }
            stage('(Docker) Archive') {
              steps {
                sh 'mv fpcsrc/ fpc/src/'
                sh 'zip -r fpc-linux-x86_64.zip fpc/'
                archiveArtifacts artifacts: 'fpc-*.zip'
              }
            }
          }
        }
        stage('Windows') {
          agent {
            label 'windows-cge-builder'
          }
          stages {
            stage('(Windows) Cleanup') {
              steps {
                sh 'rm -Rf fpcsrc/ fpc/ fpc-*.zip'
                sh 'mkdir -p fpc/'
              }
            }
            stage('(Windows) Get FPC sources') {
              steps {
                sh 'git clone https://gitlab.com/freepascal.org/fpc/source.git --depth 1 --single-branch --branch "${FPC_BRANCHTAG}" fpcsrc'
              }
            }
            stage('(Windows) Build and install FPC') {
              steps {
                dir ('fpcsrc/') {
                  sh 'make clean all install INSTALL_PREFIX="${WORKSPACE}"/fpc'
                  sh 'make clean' // clean after build, as we'll package this fpcsrc directory
                }
              }
            }
            stage('(Windows) Archive') {
              steps {
                sh 'mv fpcsrc/ fpc/src/'
                sh 'zip -r fpc-win64-x86_64.zip fpc/'
                archiveArtifacts artifacts: 'fpc-*.zip'
              }
            }
          }
        }
      }
    }
  }
  post {
    regression {
      mail to: 'michalis@castle-engine.io',
        subject: "[jenkins] Build started failing: ${currentBuild.fullDisplayName}",
        body: "See the build details on ${env.BUILD_URL}"
    }
    failure {
      mail to: 'michalis@castle-engine.io',
        subject: "[jenkins] Build failed: ${currentBuild.fullDisplayName}",
        body: "See the build details on ${env.BUILD_URL}"
    }
    fixed {
      mail to: 'michalis@castle-engine.io',
        subject: "[jenkins] Build is again successful: ${currentBuild.fullDisplayName}",
        body: "See the build details on ${env.BUILD_URL}"
    }
  }
}
