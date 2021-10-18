# minikube
- ## Activate:
```bash
minikube start --kubernetes-version=v1.20.0
kubectl config set current-context minikube
```

Additionally, for each new terminal:
```bash
eval $(minikube docker-env)
```
^ Only technically necessary for `docker build`, but better safe than sorry.

- ## Deactivate:
```bash
minikube stop
eval $(minikube docker-env -u)
kubectl config set current-context gke_cs4215-21-22_us-central1-c_fltk-cluster
```

# Enable venv
```bash
cd ~/fltk-testbed
source venv/bin/activate
```

# Dashboard
- ## Remote:
```bash
helm status kubernetes-dashboard -n default
```
Follow instructions from command above to port-forward.

Make sure to have `default-pool` scaled up in gcloud.

In dashboard browser tab, do not forget to change to desired namespace.

- ## minikube:
```bash
minikube dashboard --url
```

# Status info
- ## List helm releases in namespace
```bash
helm ls -n <namespace>
```
Default should contain:
- kubernetes-dashboard _(if in remote)_

Test should contain:
- nfs-server
- extractor
- orchestrator*

- ## List kubectl jobs in namespace
```bash
kubectl get pods -n <namespace>
```

- ## List cluster configurations
```bash
kubectl config get-contexts
```

# Extractor & Orchestrator basics
```bash
cd ~/fltk-testbed/charts
```

- ## Add:
```bash
helm install extractor ./extractor -f fltk-values.yaml -n test
```
Port-forward instructions provided by install command. If already installed follow commands from `helm status extractor -n test` to port-forward.

```bash
helm install orchestrator ./orchestrator -f fltk-values.yaml -n test
```

When running through `minikube`, append `--set image.pullPolicy=IfNotPresent` to both commands.

- ## Remove:
```bash
helm uninstall extractor -n test
```
Removing extractor wipes existing TensorBoard results.

```bash
helm uninstall orchestrator -n test
```

Sometimes needed to clear previous jobs manually:
```bash
kubectl delete pytorchjobs --all -n test
```

# Pushing changes
```bash
cd ~/fltk-testbed
DOCKER_BUILDKIT=1 docker build . --tag gcr.io/cs4215-21-22/fltk
```

Additionally, when pushing to remote:
```bash
docker push gcr.io/cs4215-21-22/fltk
```
