# CICD Code Commit -> ECS Fargate Deployment

### Steps :

- Create a CodeCommit repo  

        aws codecommit create-repository --repository-name web-container-project --region us-east-1

- Create a ECR repo

        aws ecr create-repository --repository-name web-container-project-ecr --region us-east-1

- Create a Docker file that copies the Web Files to the Webserver rot dir [Sample : check here](./Dockerfile) (dont forget to mention the platform)

- Create a `buildspec.yml` to build the docker image nd push to ECR Repo [Sample : check here](./buildspec.yml)

- Create a New Project in Code Build `web-container-project-codebuild` 
  - choose the aws code commit as the source repo . allow to create a new service role . 
  - choose to use our `buildspec.yml` file 
  - choose the OS and platform correctly according to your docker file 

- attach a custom policies with the created role of code build to allow code build to access ecr repo & S3 for pushing Artifacts[sample Policy : check here ](https://github.com/gitmurali/aws_snippets/blob/main/ecs-cli/codeBuildServiceRole.md) 

- you can either create a `imagedefinitions.json`   [Sample : check here](./imagedefinitions.json) make sure to mention your image url there or USe the Buildspec.yml file to create it dynmically (attached in sample)

- Create a ECS Cluster 

        aws ecs create-cluster --cluster-name web-container-project-cluster --capacity-providers FARGATE --region us-east-1

    - go into ur cluster and create a service (will be specifyig later in the deployment grp)

    - create a Application Load balancer and Target group 

  
  - create a new role , choose `elastic container service` and choose 'elastic container service task'
  - Attach the necessary policies to the role. At minimum, you'll want to attach the `AmazonECSTaskExecutionRolePolicy` policy to grant ECS the necessary permissions to pull Docker images from ECR, write logs to CloudWatch Logs, and perform other necessary tasks. You can attach additional policies based on your specific requirements.
  - **Copy the ARN of this role and paste it on the task-definition**

  - Create a Task definition via Console mentioning the Container nam ad Image URi same as imagedefinition.json (oR) Add the task definition with json [Sample : check here](./task-definition.json). Make sure to change the ARN of Execution Role 

  
- Create a Aws Pipeine with all default settings choosing code commit as source and ecs deploment as deploy. mention the build stage also 

- make changes in the index.html to trigger the pipeline 