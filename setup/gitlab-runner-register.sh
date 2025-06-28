#!/bin/sh
# from https://gist.github.com/benoitpetit/cbe19cdd369ec8c1e0defd245d91751f
###################################################################
# Récuperer le token d'enregistrement du runner via ce lien:
# http://localhost/root/${project}/settings/ci_cd
# Benoit Petit: https://github.com/benoitpetit
###################################################################

# modifier avec votre token
registration_token=$1
url=http://gitlab-web

docker exec -it gitlab-runner1 \
  gitlab-runner register \
    --non-interactive \
    --registration-token ${registration_token} \
    --locked=false \
    --description docker-stable \
    --url ${url} \
    --executor docker \
    --docker-image docker:stable \
    --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" \
    --docker-network-mode gitlab-network
    
# executer le script pour inscrire le runner dans Gitlab