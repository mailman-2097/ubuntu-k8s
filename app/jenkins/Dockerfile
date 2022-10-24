FROM jenkins/jenkins:lts-jdk11

# Pipelines with Blue Ocean UI and Kubernetes
RUN jenkins-plugin-cli --plugins blueocean blueocean-dashboard kubernetes github cloudbees-folder pipeline-utility-steps octopusdeploy matrix-auth role-strategy ssh-slaves pipeline-multibranch-defaults

