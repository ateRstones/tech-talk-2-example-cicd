# Minimal Example CI/CD Setup
## Gitlab Setup
First: Because of the networking setup for the example gitlab, we have to register the hostname gitlab-web.local to point tohost. On linux we can do this by adding a line to the `/etc/hosts` file:

    grep -q "127.0.0.1 gitlab-web.local" /etc/hosts || echo "127.0.0.1 gitlab-web.local" | sudo tee -a /etc/hosts

Further we have to add a insecure registry in the docker configuration file `/etc/docker/daemon.json`:
```json
{ 
  "insecure-registries":["gitlab-web.home:5050"] 
}
```

You can edit the file using nano (you might have to create the folder first):

    sudo nano /etc/docker/daemon.json

The restart docker:

    sudo systemctl restart docker

To run the example Gitlab with Runner Setup first run (need to have docker and docker compose installed and running):

    docker compose -f setup/docker-compose.yml up -d

The first run might take some time, as the gitlab image is quite big and gitlab takes some time for the in initial startup. The state can be checked using:

    docker ps

We further need to add a dns entry for the gitlab container registry (because of strange docker dns usage):

    sudo sed -i '/gitlab-web.home/d' /etc/hosts && echo "$(docker run --rm --network gitlab-network busybox nslookup gitlab-web.home | grep Address | tail -1 | cut -d' ' -f2) gitlab-web.home" | sudo tee -a /etc/hosts

Note: To explain the command: We first get the ip of the gitlab container in its network, then we append this to the local /etc/hosts file. Further the entry is first removed to prevent duplicates

Then login into the gitlab server at [http://gitlab-web.local](http://gitlab-web.local) using the user `root`. The password can be found out by running the following command as it is randomly generated:

    docker exec gitlab-web cat /etc/gitlab/initial_root_password

We now need to connect the runner to the gitlab instance. For this, in the admin view, go to CI/CD -> Runners. Here click "Create instance runner" -> select "Run untagged jobs" -> Create runner. In step one copy the runner authentication token. Run:

    bash setup/gitlab-runner-register.sh <runner authentication token>

Gitlab is now setup to run pipelines.

## Running a minimal gitlab pipeline
First add your public ssh key to the admin account ([Gitlab documentation](https://docs.gitlab.com/18.1/user/ssh/)).

In the gitlab UI, create a new, blank project. Be sure to uncheck "Initialize repository with a README".  
Follow the add files SSH instructions for an existing folder and switch to this repository. Change "origin" to "remote" in the commands.

Push the git repository and check on the project page. A blue circle should appear, which indicates a pipeline is running. Further the pipeline can be found in the CI/CD section.
Further new pipelines can be created to run it again. The pipeline will run on every commit (with the default example).

The pipeline definition is found in the `.gitlab-ci.yml` file. It build the docker container according to the docker build file (`Dockerfile`).