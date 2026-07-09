# LibreChat Admin Panel Helm Chart

[![Helm](https://img.shields.io/badge/Helm-v3-blue?logo=helm)](https://helm.sh/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.30%2B-326CE5?logo=kubernetes)](https://kubernetes.io/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Docker Pulls](https://img.shields.io/docker/pulls/ashishmahamuni21/librechat-admin-panel)](https://hub.docker.com/r/ashishmahamuni21/librechat-admin-panel)

Deploy the **LibreChat Admin Panel** on Kubernetes using a reusable Helm chart.

This Helm chart packages the LibreChat Admin Panel as a production-ready Kubernetes application with support for Ingress, Gateway API, OpenID SSO, secure defaults, and GitOps-friendly deployments.

---

## Features

- 🚀 Production-ready Kubernetes deployment
- 📦 Helm-based installation
- 🐳 Public Docker Hub image
- 🌐 Ingress support
- 🔀 Gateway API HTTPRoute support
- 📈 Horizontal Pod Autoscaler (HPA)
- 🛡️ Pod Disruption Budget (PDB)
- 🔒 NetworkPolicy support
- 🔐 Kubernetes Secret integration
- ❤️ Liveness & Readiness probes
- 👤 Pod & Container Security Contexts
- 🔑 OpenID SSO support
- ☸️ GitOps friendly
- 🏷️ Dedicated Kubernetes labels to avoid Service selector collisions

---

# Prerequisites

- Kubernetes **1.30+**
- Helm **3.15+**
- A running LibreChat deployment

---

# Quick Start

## Add the Helm Repository

```bash
helm repo add librechat-admin-panel https://ashishmahamuni21.github.io/librechat-admin-panel
helm repo update
```

## Create the Required Secret

The application requires a `SESSION_SECRET` with **at least 32 characters**.

```bash
kubectl create secret generic librechat-admin-panel-env \
  --namespace librechat \
  --from-literal=SESSION_SECRET="$(openssl rand -hex 32)"
```

## Install the Chart

```bash
helm install admin librechat-admin-panel/librechat-admin-panel \
  --namespace librechat \
  --create-namespace
```

Or install using your own configuration:

```bash
helm install admin librechat-admin-panel/librechat-admin-panel \
  --namespace librechat \
  --create-namespace \
  --values values.yaml
```

---

# Upgrade

```bash
helm upgrade admin librechat-admin-panel/librechat-admin-panel \
  --namespace librechat \
  --values values.yaml
```

---

# Uninstall

```bash
helm uninstall admin -n librechat
```

---

# Docker Image

The Helm chart uses the public Docker image available on Docker Hub.

```bash
docker pull ashishmahamuni21/librechat-admin-panel:latest
```

Image reference:

```yaml
image:
  registry: docker.io
  repository: ashishmahamuni21/librechat-admin-panel
  tag: latest
  pullPolicy: IfNotPresent
```

---

# Example values.yaml

```yaml
replicaCount: 1

image:
  registry: docker.io
  repository: ashishmahamuni21/librechat-admin-panel
  tag: latest
  pullPolicy: IfNotPresent

existingSecretName: librechat-admin-panel-env

env:
  PORT: "3000"
  NODE_ENV: production

  ADMIN_SSO_ENABLED: "true"
  ADMIN_SSO_ONLY: "true"

  SESSION_COOKIE_SECURE: "true"

  VITE_API_BASE_URL: "https://librechat.example.com"

  API_SERVER_URL: "http://librechat.default.svc.cluster.local:3080"

ingress:
  enabled: true

  className: nginx

  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"

  hosts:
    - host: admin-panel.example.com
      paths:
        - path: /
          pathType: Prefix

  tls:
    - secretName: admin-panel-tls
      hosts:
        - admin-panel.example.com
```

---

# OpenID Single Sign-On

Enable SSO:

```yaml
env:
  ADMIN_SSO_ENABLED: "true"
```

To require SSO-only authentication:

```yaml
env:
  ADMIN_SSO_ONLY: "true"
```

LibreChat should also be configured with:

```text
ADMIN_PANEL_URL=https://admin-panel.example.com
```

This allows LibreChat to generate the correct OAuth callback URLs.

---

# Networking

The chart supports two methods for exposing the application.

## Kubernetes Ingress

```yaml
ingress:
  enabled: true
```

## Gateway API

```yaml
httpRoute:
  enabled: true
```

Use either **Ingress** or **Gateway API**, depending on your Kubernetes environment.

---

# Security

The chart includes production-oriented security defaults:

- Runs as a non-root user
- RuntimeDefault seccomp profile
- Drops Linux capabilities
- Disables privilege escalation
- Supports NetworkPolicy
- Supports external Kubernetes Secrets
- Pod Security Context
- Container Security Context

---

# Operational Checks

Verify the Pods:

```bash
kubectl get pods \
  -n librechat \
  -l app.kubernetes.io/component=admin-panel
```

Verify the Service:

```bash
kubectl get svc -n librechat
```

Verify the Endpoints:

```bash
kubectl get endpoints librechat-admin-panel \
  -n librechat
```

View logs:

```bash
kubectl logs deploy/librechat-admin-panel \
  -n librechat
```

---

# Troubleshooting

## SESSION_SECRET error

```
SESSION_SECRET must be set to at least 32 characters
```

Verify the Kubernetes Secret exists and contains a value of at least 32 characters.

---

## OAuth redirects to localhost

Ensure LibreChat is configured with:

```text
ADMIN_PANEL_URL=https://admin-panel.example.com
```

---

## Browser cannot reach LibreChat

Verify:

```yaml
VITE_API_BASE_URL
```

points to the browser-facing LibreChat URL.

---

## Internal API communication fails

Verify:

```yaml
API_SERVER_URL
```

points to the internal Kubernetes Service.

---

## Service has no Endpoints

Ensure the Service selector matches the Deployment labels:

```yaml
app.kubernetes.io/component: admin-panel
```

---

# Why This Helm Chart?

Deploying the LibreChat Admin Panel in Kubernetes involves more than just running a container.

This Helm chart provides:

- Repeatable deployments
- Kubernetes best practices
- Secure defaults
- GitOps compatibility
- Production-ready configuration
- Optional Ingress and Gateway API support
- Easier upgrades and rollbacks
- Clean secret management
- Stable Service selectors

---

# Resources

## 📦 Docker Image

https://hub.docker.com/r/ashishmahamuni21/librechat-admin-panel

---

## ☸️ Helm Repository

https://github.com/ashishmahamuni21/librechat-admin-panel

---

## 💻 GitHub Repository

https://github.com/ashishmahamuni21/librechat-admin-panel

---

## 📖 Deployment Guide

Read the complete deployment guide on Medium:

> https://medium.com/@ashishmahamuni21 *(Update this link after publishing.)*

---

# Contributing

Contributions, issues, feature requests, and pull requests are welcome.

If you find this project useful, consider:

- ⭐ Starring the repository
- 🐛 Opening issues
- 💡 Suggesting improvements
- 🤝 Contributing pull requests

---

# License

This project is licensed under the **MIT License**.

---

## Keywords

LibreChat, LibreChat Admin Panel, Kubernetes, Helm, Helm Chart, Docker, Docker Hub, GitOps, DevOps, Platform Engineering, AI, LLM, MCP, LiteLLM, OpenID, OAuth, Gateway API, Ingress
