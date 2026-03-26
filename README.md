#  Terraform AWS EC2 Secure Web Nodes (Hardened Setup)

##  Project Overview

This project demonstrates provisioning of secure EC2 instances on AWS using Terraform with automated hardening.

The infrastructure follows a **security-first approach**, ensuring strict access control and eliminating unnecessary privileges.

---

##  Key Features

*  SSH key-based authentication only
*  Root login disabled
*  No sudo access (no privilege escalation)
*  Custom non-root user (`devops`)
*  Automated provisioning using Terraform `user_data`

---

## Tech Stack

* Terraform
* AWS EC2 (Amazon Linux 2023)
* Cloud-init (`user_data`)
* SSH

---

##  Project Structure

```
.
├── main.tf
├── outputs.tf
├── screenshots/
│   └── ssh-proof.png
├── README.md
├── .gitignore
```

---

##  Prerequisites

* AWS CLI configured (`aws configure`)
* Terraform installed
* AWS Key Pair created (e.g., `nac`)
* Private key available locally (`.pem` file)

---

## Infrastructure Details

### EC2 Configuration

* AMI: `ami-0aaa636894689fa47`
* Instance Type: `t3.micro`
* Region: `eu-north-1`
* Instances: 2 (web nodes)

---

## Deployment Steps

### 1. Initialize Terraform

```
terraform init
```

### 2. Plan Infrastructure

```
terraform plan
```

### 3. Apply Configuration

```
terraform apply
```

---

## Output Example

```
public_ips = [
  "<IP1>",
  "<IP2>"
]
```

---

##  SSH Access

### Fix Key Permissions

```
chmod 400 ~/Downloads/nac.pem
```

### Connect to Instance

```
ssh -i ~/Downloads/nac.pem devops@<public-ip>
```

---



![SSH Proof](https://raw.githubusercontent.com/Sheshadri-MO/terraform-secure-ec2/main/screenshots/ssh-proof.png)

 This screenshot demonstrates:

* Successful login using `devops` user
* Root login disabled
* No sudo access (restricted privileges)

---

## Security Validation

### 1. Confirm user

```
whoami
```

Expected:

```
devops
```

### 2. Root login should fail

```
ssh root@<ip>
```

### 3. Sudo access should fail

```
sudo su
```

Expected:

```
devops is not in the sudoers file
```

---

## Common Issues & Fixes

### Permission denied (SSH)

```
chmod 400 nac.pem
```

###  Connection timed out

* Ensure Security Group allows port 22

###  DevOps login fails

```
terraform destroy
terraform apply
```

---
