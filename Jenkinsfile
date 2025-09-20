pipeline {
  agent any
  options { timestamps(); buildDiscarder(logRotator(numToKeepStr: '25')) }
  parameters {
    choice(name: 'ACTION', choices: ['plan','apply','destroy'], description: 'Terraform action')
    string(name: 'AWS_REGION',        defaultValue: 'us-east-1', description: 'AWS region')
    string(name: 'KEY_NAME',          defaultValue: '886436941748_NV-Mar-25', description: 'EC2 key pair name (not .pem path)')
    string(name: 'INSTANCE_NAME',     defaultValue: 'demo-ec2', description: 'EC2 Name tag')
    string(name: 'SUBNET_ID',         defaultValue: 'subnet-CHANGE-ME', description: 'Existing subnet ID')
    string(name: 'SECURITY_GROUP_ID', defaultValue: 'sg-0c20946163121270b', description: 'Existing security group ID')
  }
  environment { TF_IN_AUTOMATION = 'true' }
  stages {
    stage('Checkout') { steps { checkout scm } }
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
          script {
            def base = 'terraform'
            def commonVars = """
              -var="aws_region=${params.AWS_REGION}"
              -var="key_name=${params.KEY_NAME}"
              -var="instance_name=${params.INSTANCE_NAME}"
              -var="subnet_id=${params.SUBNET_ID}"
              -var="security_group_id=${params.SECURITY_GROUP_ID}"
            """.trim().replaceAll('\\s+',' ')
            if (params.ACTION == 'plan') {
              sh "${base} plan -input=false -no-color ${commonVars}"
            } else if (params.ACTION == 'apply') {
              sh "${base} apply -auto-approve -input=false -no-color ${commonVars}"
            } else {
              sh "${base} destroy -auto-approve -input=false -no-color ${commonVars}"
            }
          }

          // If you *don’t* use an instance role on the agent, uncomment and add credentials:
          // withCredentials([
          //   string(credentialsId: 'aws-access-key-id',     variable: 'AWS_ACCESS_KEY_ID'),
          //   string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
          // ]) {
          //   sh "terraform plan -input=false -no-color ${commonVars}"
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

