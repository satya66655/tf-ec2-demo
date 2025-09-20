pipeline {
  agent any
  options { timestamps(); ansiColor('xterm'); buildDiscarder(logRotator(numToKeepStr: '25')) }
  parameters {
    choice(name: 'ACTION', choices: ['plan','apply','destroy'], description: 'Terraform action')
    string(name: 'AWS_REGION', defaultValue: 'us-east-1', description: 'AWS region')
    string(name: 'KEY_NAME', defaultValue: '886436941748_NV-Mar-25', description: 'EC2 key pair name (not .pem path)')
    string(name: 'INSTANCE_NAME', defaultValue: 'demo-ec2', description: 'Tag/Name for the instance')
  }
  environment {
    TF_IN_AUTOMATION = 'true'
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Tools check') {
      steps {
        sh 'terraform -version'
        sh 'aws --version || true'
      }
    }

    stage('Validate') {
      steps {
        dir('terraform') {
          sh 'terraform init -input=false'
          sh 'terraform validate -no-color'
        }
      }
    }

    stage('Plan / Apply / Destroy') {
      steps {
        dir('terraform') {
          // ----- OPTION A: Instance role on the agent (no secrets needed) -----
          script {
            def base = 'terraform'
            def commonVars = "-var=\"aws_region=${params.AWS_REGION}\" -var=\"key_name=${params.KEY_NAME}\" -var=\"instance_name=${params.INSTANCE_NAME}\""
            if (params.ACTION == 'plan') {
              sh "${base} plan -input=false -no-color ${commonVars}"
            } else if (params.ACTION == 'apply') {
              sh "${base} apply -auto-approve -input=false -no-color ${commonVars}"
            } else {
              sh "${base} destroy -auto-approve -input=false -no-color ${commonVars}"
            }
          }

          // ----- OPTION B: Use stored access keys (uncomment if you used Credentials Binding) -----
          // withCredentials([
          //   string(credentialsId: 'aws-access-key-id',     variable: 'AWS_ACCESS_KEY_ID'),
          //   string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
          // ]) {
          //   script {
          //     def base = 'terraform'
          //     def commonVars = "-var=\"aws_region=${params.AWS_REGION}\" -var=\"key_name=${params.KEY_NAME}\" -var=\"instance_name=${params.INSTANCE_NAME}\""
          //     if (params.ACTION == 'plan') {
          //       sh "${base} plan -input=false -no-color ${commonVars}"
          //     } else if (params.ACTION == 'apply') {
          //       sh "${base} apply -auto-approve -input=false -no-color ${commonVars}"
          //     } else {
          //       sh "${base} destroy -auto-approve -input=false -no-color ${commonVars}"
          //     }
          //   }
          // }
        }
      }
      post {
        success { echo "${params.ACTION} succeeded" }
        failure { echo "${params.ACTION} failed" }
      }
    }
  }
  post { always { cleanWs() } }
}

