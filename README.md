# Minimal Example CI/CD Setup
## Gitlab Setup
To run the example Gitlab with Runner Setup first run (need to have docker and docker compose installed and running):

    docker compose -f setup/docker-compose.yml up -d

The first run might take some time, as the gitlab image is quite big and gitlab takes some time for the in initial startup. The state can be checked using:

    docker ps

Then login into the gitlab server at [http://localhost](http://localhost) using the user `root`. The password can be found out by running the following command as it is randomly generated:

    docker exec gitlab-web cat /etc/gitlab/initial_root_password

We now need to connect the runner to the gitlab instance. For this, in the admin view, go to CI/CD -> Runners. Here click "Create instance runner" -> select "Run untagged jobs" -> Create runner. In step one copy the runner authentication token. Run:

    bash setup/gitlab-runner-register.sh <runner authentication token>

Gitlab is now setup to run pipelines.

## Running a minimal gitlab pipeline
First add your public ssh key to the admin account ([Gitlab documentation](https://docs.gitlab.com/18.1/user/ssh/)).

In the gitlab UI, create a new, blank project. Be sure to uncheck "Initialize repository with a README".  
Follow the add files SSH instructions for an existing folder and switch to this repository. Change "origin" to "remote" in the commands.