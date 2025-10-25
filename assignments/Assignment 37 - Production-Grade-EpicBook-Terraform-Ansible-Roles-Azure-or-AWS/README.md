Full Project Structure:
Theepicbook
Terraform
├─ backend.tf       ├─ locals.tf
├─ variables.tf
├─ main.tf
├─ outputs.tf
├─ env/
│  └─ dev.tfvars
└─ modules/
   ├─ network/
   │  ├─ main.tf
   │  ├─ variables.tf
   │  └─ outputs.tf
   ├─ database/
   │  ├─ main.tf
   │  ├─ variables.tf
   │  └─ outputs.tf
   └─ compute/
      ├─ main.tf
      ├─ variables.tf
      └─ outputs.tf
theepicbook-ansible/
├─ ansible.cfg
├─ inventory/
│  └─ prod.ini
├─ playbooks/
│  └─ site.yml
└─ roles/
   ├─ mysql/
   ├─ nodejs/
   ├─ nginx/
   └─ app/



Imp Links:
Repo : https://github.com/pravinmishraaws/theepicbook.git
Assignment Info: https://github.com/pravinmishraaws/DevOps-Micro-Internship/blob/9ff9a03d26f899f5ff900e8735e6df7e4ab65fb5/Week%208%20-%20Ansible%20Assignment/Assignment%2037%3A%20Production-Grade%20EpicBook%20%E2%80%94%20Terraform%20%2B%20Ansible%20Roles%20%28Azure%20or%20AWS%29.md


1. What is an Ansible Role?

An Ansible role is a structured way to organize automation tasks, handlers, files, templates, and variables into reusable units. Roles make your playbooks cleaner, modular, and easier to maintain.

Without roles, everything is in one big playbook (site.yml) → hard to manage.

With roles, you can split responsibilities into different directories like mysql, nginx, nodejs, app.

2. Typical Directory Structure of a Role

When you create a role (e.g., mysql), the structure looks like this:

roles/
└─ mysql/
   ├─ tasks/
   │   └─ main.yml       # Main tasks to configure MySQL
   ├─ handlers/
   │   └─ main.yml       # Handlers for restart/reload services
   ├─ templates/
   │   └─ my.cnf.j2      # Jinja2 templates for configuration files
   ├─ files/
   │   └─ init.sql        # Static files or SQL scripts to copy
   ├─ vars/
   │   └─ main.yml       # Role-specific variables
   ├─ defaults/
   │   └─ main.yml       # Default variables (lowest priority)
   └─ meta/
       └─ main.yml       # Metadata, dependencies

Explanation of each folder:
Folder	Purpose
tasks/	Contains main YAML files with steps/tasks. main.yml is automatically executed when role is called.
handlers/	Special tasks triggered by other tasks (e.g., notify: restart mysql). Usually for restarting services after config changes.
templates/	Jinja2 templates to dynamically generate configuration files (e.g., my.cnf, nginx.conf).
files/	Static files to copy to target hosts (e.g., SQL scripts, certificates).
vars/	Variables specific to this role with high priority.
defaults/	Default variables for the role (can be overridden by vars in playbook or inventory).
meta/	Metadata like dependencies on other roles.
3. How Roles Are Used in a Playbook

Roles are included in a playbook like this:

---
- hosts: all
  become: yes
  vars:
    mysql_admin_password: "StrongPassword123!"
  roles:
    - mysql
    - nodejs
    - nginx
    - app


The roles section tells Ansible to execute the main.yml task file of each role.

Variables can be passed in the playbook or in the inventory.

Step-by-Step Example: Using the mysql Role

tasks/main.yml in mysql role:

---
- name: Install MySQL server
  apt:
    name: mysql-server
    state: present
    update_cache: yes

- name: Ensure MySQL is running
  service:
    name: mysql
    state: started
    enabled: yes

- name: Create MySQL user
  mysql_user:
    name: epicbook_user
    password: "{{ mysql_admin_password }}"
    priv: "*.*:ALL"
    host: "%"


handlers/main.yml:

---
- name: restart mysql
  service:
    name: mysql
    state: restarted


playbook/site.yml:

- hosts: all
  become: yes
  vars:
    mysql_admin_password: "StrongPassword123!"
  roles:
    - mysql


Explanation:

When the playbook runs:

Installs MySQL.

Starts the service.

Creates a user with given password.

Any task can call notify: restart mysql to trigger the handler.

4. Advantages of Using Roles

Reusability – Use the same role in multiple playbooks or projects.

Modularity – Each role focuses on a specific component (MySQL, Node.js, Nginx, App).

Readability – Playbooks are cleaner; you don’t need to include hundreds of tasks in one file.

Ease of Maintenance – Updating a role updates all playbooks that use it.

Collaboration – Teams can work on different roles simultaneously.

5. Running Roles Individually

You can also run a single role without the full playbook:

ansible-playbook -i inventory/prod.ini playbooks/site.yml --tags mysql


Here, you can tag tasks in tasks/main.yml with tags: mysql.

Useful for debugging or rerunning a specific part of the deployment.

6. Best Practices

Use defaults/main.yml for values that can be overridden.

Keep sensitive data (passwords) in Vault or external secrets manager.

Use templates instead of copying static configs for dynamic customization.

Always use handlers for restarting services instead of restarting after every task.

✅ Summary:
Roles are the backbone of structured Ansible automation. They help you separate concerns, improve readability, and make your playbooks maintainable. In your assignment:

mysql → installs/configures database

nodejs → installs Node.js runtime

nginx → reverse proxy / web server

app → deploys EpicBook app code, configures services


---------------------------------------------------------------------------------------------------------------------------------------------------------------------


