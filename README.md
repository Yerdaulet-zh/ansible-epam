# EPAM Ansible & Terraform Infrastructure Suite

An enterprise-grade **Infrastructure Automation Framework** designed to provision cloud infrastructure using **Terraform** and configure it with **Ansible**.

The project follows modern **Infrastructure-as-Code (IaC)** principles including:

- Modularity
- Idempotency
- Environment isolation
- Reusable automation components

This repository demonstrates a **two-layer infrastructure model** where infrastructure provisioning and configuration management are clearly separated.

---

# Architecture Overview

The project is organized into **two distinct layers** to maintain separation of concerns.

---

## 1. Infrastructure Layer (`epam-terraform/`)

This layer provisions the cloud infrastructure using **Terraform**.

### VPC Module
Creates the networking foundation:

- VPC
- Public / Private Subnets
- Internet Gateway
- Route Tables
- Security Groups

### EC2 Module
Responsible for compute resources.

Features:

- Dynamic **AMI lookup** via Terraform `data` sources
- Parameterized instance configuration
- Security group attachment

### Remote Backend
Supports **remote Terraform state management** to enable collaboration between multiple engineers.

Benefits:

- Prevents state conflicts
- Enables team workflows
- Supports CI/CD integration

---

## 2. Configuration Layer (Ansible)

Once infrastructure is provisioned, **Ansible** handles server configuration.

The automation follows a **role-based architecture** designed for scalability and OS compatibility.

### Roles

#### `common`
Baseline configuration applied to all nodes.

Responsibilities:

- OS package management
- System updates
- Basic security hardening
- OS-aware task execution

#### `collectd`
Monitoring agent deployment and management.

Features:

- Jinja2-based dynamic configuration
- Service lifecycle management
- Install / remove support

---

# Repository Structure

```
.
├── ansible.cfg
│
├── epam-terraform/
│   ├── vpc/
│   └── ec2/
│
├── inventory/
│   ├── dev/
│   │   ├── group_vars/
│   │   │   └── managed_nodes.yml
│   │   └── hosts.ini
│   │
│   └── prod/
│
├── playbooks/
│   ├── deploy_common.yml
│   └── manage_collectd.yml
│
├── roles/
│   ├── common/
│   └── collectd/
│
└── requirements.yaml
```

---

# Getting Started

## Prerequisites

Ensure the following tools are installed:

- **Ansible ≥ 2.13**
- **Terraform ≥ 1.x**
- **SSH private key** with correct permissions

```bash
chmod 400 <key_file>
```

---

# Step 1 — Provision Infrastructure

Navigate to the Terraform modules and apply them sequentially.

```bash
cd epam-terraform/vpc
terraform init
terraform apply
```

```bash
cd ../ec2
terraform init
terraform apply
```

---

# Step 2 — Configure Servers

Execute Ansible playbooks from the **repository root**.

Ensure you point Ansible to the **correct environment inventory**.

### Deploy Baseline Configuration

```bash
ansible-playbook -i inventory/dev playbooks/deploy_common.yml
```

### Deploy Monitoring (Collectd)

```bash
ansible-playbook -i inventory/dev playbooks/manage_collectd.yml
```

---

# Core Features

## OS-Aware Task Execution

The `common` role uses:

```yaml
ansible_os_family
```

to ensure **distribution-specific tasks** are executed safely.

Example:

- SELinux tasks run only on **RedHat-based systems**
- Automatically skipped on **Ubuntu / Debian**

---

## Dynamic Configuration via Jinja2

The `collectd` role dynamically generates configuration files using **Jinja2 templates**, enabling:

- Custom ports
- Metric selection
- Flexible monitoring configuration

---

## Service Lifecycle Management

The `collectd` role supports full lifecycle operations using the variable:

```yaml
collectd_state
```

Supported values:

- `present` → install and start collectd
- `absent` → uninstall and clean configuration

---

## Enterprise Output Formatting

The `ansible.cfg` configuration enables **clean, professional terminal output**:

```ini
stdout_callback = default
result_format = yaml
```

This improves readability and debugging.

---

# Troubleshooting

### SELinux Errors on Ubuntu

If you encounter errors related to the **selinux Python module**, ensure the following conditional exists:

```yaml
when: ansible_os_family == "RedHat"
```

---

### SSH Permission Denied

Verify:

- Correct `private_key_file` path in **ansible.cfg**
- `remote_user` set correctly (commonly `ubuntu` for AWS)

Example:

```ini
remote_user = ubuntu
```

---

### Python Interpreter Warnings

Suppress interpreter discovery warnings by defining:

```yaml
ansible_python_interpreter: /usr/bin/python3
```

in:

```
inventory/*/group_vars/
```

---

# Author

**Yerdaulet Zhumabay**

Software Engineer | DevOps Engineer

Specializing in:

- Infrastructure as Code
- Kubernetes & Cloud Architecture
- AI / ML Systems Infrastructure