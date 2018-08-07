pipeline {
  agent any
  stages {
    stage('first_step') {
      parallel {
        stage('first_step') {
          steps {
            build(job: 'install_Nagios.sh', propagate: true, quietPeriod: 30, wait: true)
          }
        }
        stage('first_step_v2') {
          steps {
            echo 'hello amjad'
          }
        }
      }
    }
    stage('sec_step') {
      steps {
        echo 'sec'
      }
    }
  }
}
