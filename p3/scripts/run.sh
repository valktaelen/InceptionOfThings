#!/usr/bin/env bash

# argo-cd_stable_manifests.yaml

# --- helper functions for logs ---
info()
{
    echo '[INFO] ' "$@"
}

setup_argocd() {
    VERSION=v2.5.4

    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/$VERSION/manifests/install.yaml

    # Expose ArgoCD with LoadBalancer service
    kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

    # Wait for the external IP to be created
    while [ -z "$(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].ip}')" ]; do
        sleep 1
    done

    info 'Done'
}

setup_argocd
