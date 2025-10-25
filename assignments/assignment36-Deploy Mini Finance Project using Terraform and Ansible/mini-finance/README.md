mini-finance/
├─ terraform/
├─ ansible/
│  └─ files/
└─ README.md

🧾 README.md — Assignment 36: Mini Finance Website (Terraform + Ansible)
🔹 Overview

This project automates the deployment of a static Mini Finance website on Azure using Terraform for infrastructure provisioning and Ansible for configuration management.

It includes:

Creation of Resource Group, VNet, Subnet, NSG, Public IP, NIC, and VMs.

Automatic association of Subnet ↔ NSG.

Installation of Nginx and deployment of a static website (HTML + CSS).

🪄 1️⃣ Terraform Setup

Folder: mini-finance/terraform/

Files:

providers.tf — Azure provider and authentication

main.tf — main infrastructure definition

variables.tf — reusable variables

Commands used:

terraform init
terraform validate
terraform plan
terraform apply -auto-approve


Issues encountered + Fixes:

Error	Cause	Fix
subnet not associated with NSG	Association missing in Terraform	Added azurerm_subnet_network_security_group_association resource
Authentication error	Azure CLI not logged in	az login
State file committed accidentally	.gitignore missing	Added .terraform/ and *.tfstate to .gitignore
🧰 2️⃣ Ansible Setup

Folder: mini-finance/ansible/

Files:

inventory.ini

site.yml

files/ → contains index.html, style.css, etc.

Commands used:

ansible-playbook -i inventory.ini site.yml


Errors & Fixes:

Error	Message	Fix
Could not find or access 'files/*'	Wrong path	Corrected to src: "{{ playbook_dir }}/files/"
Unsupported parameters for copy: recurse	Wrong module usage	Used ansible.builtin.copy with with_filetree or loop
Website had no CSS	CSS not copied	Added copy task to include all files in files/ folder
🌐 3️⃣ Website Verification

After running Ansible, verified website with:

curl http://<public_ip>


Expected: index.html and style.css loaded successfully.

🧩 4️⃣ Git Version Control

Branching Steps:

git checkout -b assignment36
# added Terraform + Ansible files
git add .
git commit -m "Assignment 36 - Mini Finance Automation"


Push to GitHub:

git push -u origin assignment36


.gitignore Highlights:

.terraform/
*.tfstate
*.pem
*.key
.venv/
*.retry

✅ 5️⃣ Summary

Automated Azure VM deployment using Terraform.

Installed and configured Nginx with Ansible.

Deployed static Mini Finance website with HTML + CSS.

Solved multiple YAML, path, and Terraform association issues.

Cleanly managed Git branches and .gitignore.
