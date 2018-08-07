pipeline {
  agent any
  stages {
    stage('first_step') {
      parallel {
        stage('first_step') {
          steps {
            build(job: 'job1', propagate: true, quietPeriod: 2, wait: true)
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