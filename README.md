# aws-ecs-fargate-action
How to setup a CD for AWS ECS with Fargate

## Docker
First, create an application that has a buildable Docker image.

## Resources
Then, create
- an Elastic Container Registry to store your Docker images, save its name for later. Remember to allow tag mutability, such that the `latest` tag can be updated.
- an Elastic Container Service cluster to run your containers
- an ECS task definition, which specifies which containers should run, which ports to open, how much resources, etc. Remember to use the `latest` tag for your image, so that you don't need to update the task definition when there is a container update.
- an ECS service, which will run your task definition.
  - You'll see that there are "services" and "tasks". Services will guarantee that your task will always stay up, while tasks should be used for one-off jobs, since they will not restart when the containers stop or fail. Therefore, we will use a Service here.

## IAM user
Create an IAM user with a policy that is able to push and tag new images to your ECR repository (it's best to allow pushes/tags to only a specific repository, and not all repositories of your account), and that is also able to update your ECS service. Create an access key with a secret, and store both in GitHub secrets:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
Also, store in an AWS_REGION GitHub secret your AWS region.

## Workflow
The workflow in this repository will run whenever a tag specifying a release-number regex (like "0.4.3") is pushed. Then, it will
- Build the docker image as `latest`
- Tag `latest` with the current version (eg "0.4.3")
- Push both of them to the ECR registry (creating a new version in the repo, and pointing `latest` to the current version).
- Force update the service. Since the task definition wont't change (as it uses the `latest` tag, remember?), we need to restart the service, such that it stops the current tasks and creates new ones, therefore using the current `latest` tag.

## Make it better
Next steps:
- Make CI run only when source files change (and not the README for example)
- Make CD run only when CI runs successfully
- Createa a GitHub release when CD runs
