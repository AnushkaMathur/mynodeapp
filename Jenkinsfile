node{
    
//variables
//github
git_url='https://github.com/AnushkaMathur/mynodeapp.git'
env.tag=BUILD_NUMBER
//docker
docker_registry_url='https://360913885216.dkr.ecr.us-east-1.amazonaws.com/mynode'
docker_repo='360913885216.dkr.ecr.us-east-1.amazonaws.com/mynode'
//ecs
env.region='us-east-1'
env.family="nodeapp-td"
env.service_name="node-svc"
env.cluster_name="craft"
env.ecs_server='360913885216.dkr.ecr.us-east-1.amazonaws.com'
env.repo='360913885216.dkr.ecr.us-east-1.amazonaws.com/mynode'
env.stackname="nodedeploy"

   stage('Clean WorkSpace'){
       sh 'rm -rf *'
   }
   stage('Git') { 
      // Get some code from a GitHub repository
          git credentialsId: 'github', url: git_url
      
   }
   
   stage('Build Docker Image') {
      sh 'aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $ecs_server'


      docker.withRegistry(docker_registry_url) {
        docker.build(docker_repo)
      }
   }
   stage('Push Image to ECR'){
     docker.withRegistry(docker_registry_url) {
        docker.image(docker_repo).push('$tag')
      }  
   }
   
    stage('Image cleanup'){
       docker.withRegistry(docker_registry_url) {
           env.imagename = docker_repo
           sh 'echo removing $imagename and $imagename:$tag'
           sh 'docker rmi $imagename $imagename:$tag'
       }
   }
   
     stage('ECS Deployment'){

    env.new_docker_image=docker_repo+":"+env.tag
    sh '''
  stackexists= $(aws cloudformation describe-stacks | jq '.Stacks[].StackName' | grep $stackname)
'''
  if ( $stackexists == $stackname ) {
      sh '''
      aws cloudformation update-stack --stack-name $stackname --template-body file://nodetest.yaml --parameters ParameterKey=Family,ParameterValue=$family ParameterKey=ServiceName,ParameterValue=$service_name ParameterKey=ClusterName,ParameterValue=$cluster_name  ParameterKey=Image,ParameterValue=$repo":"$tag 
      '''
  }
  else {
      sh '''
aws cloudformation create-stack --stack-name $stackname --template-body file://nodetest.yaml --parameters ParameterKey=Family,ParameterValue=$family ParameterKey=ServiceName,ParameterValue=$service_name ParameterKey=ClusterName,ParameterValue=$cluster_name  ParameterKey=Image,ParameterValue=$repo":"$tag 
   '''   }    
     }}
