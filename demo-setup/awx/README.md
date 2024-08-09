# AWX automated rollout and configuration
#### v 0.2 230307

This set of playbooks will roll out an AWX Instance on Openshift or Microshift (Other Kubernetes Distros possible, change "Route"-Code to "Ingress")

### Requirements:
 - Kubernetes Node or Cluster, Auth via kubeconfig file
 - AWX-Operator installed on Kuberentes Setup

### Customization:
  - Add Credentials to secrets.yml. It's recommended to encrypt it with vault, after keys and passwords have been inserted. Run the Playbook with "--ask-vault-pass" to include encrypted secrets
  - Add your AWX confiuration as code into vars.yml

### further customization
 - add additional variables into vars and 02_awx_config as needed. Exmples: Workflow templates or additional Template fields like Instance Groups
 - add options for dynamic Inventories

