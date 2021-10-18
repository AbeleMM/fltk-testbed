#!/bin/sh

# To make script executable for everyone, execute:
# chmod 0755 redeploy.sh
# Also ensure line endings are LF.

cd "${0%/*}" # set working dir to be that of the script
cd ..
helm uninstall orchestrator -n test
kubectl delete pytorchjobs --all -n test
DOCKER_BUILDKIT=1 docker build . --tag gcr.io/cs4215-21-22/fltk
docker push gcr.io/cs4215-21-22/fltk
cd charts
helm install orchestrator ./orchestrator -f fltk-values.yaml -n test
