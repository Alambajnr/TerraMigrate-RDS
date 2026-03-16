
### Updated Professional README.md (Cloud-to-Cloud Version)

```markdown
# AWS Cloud Data Migration: RDS MySQL to Amazon Aurora/RDS

[![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)

## 📌 Project Overview
This repository contains a full-stack **Infrastructure as Code (IaC)** deployment of a cloud-to-cloud database migration pipeline. It demonstrates how to migrate a live e-commerce workload between AWS RDS instances using **AWS Database Migration Service (DMS)**.

By leveraging Change Data Capture (CDC), this project achieves a near-zero downtime migration, ensuring data consistency between a source "Legacy" cloud database and a modern "Target" cloud environment.

### Key Features:
* **Infrastructure as Code:** 100% automated provisioning using Terraform modules.
* **Live Synchronization:** Utilizes CDC to replicate ongoing transactions during the migration.
* **Network Security:** Implements fine-grained Security Group rules to bridge the DMS Replication Instance and RDS clusters.
* **Modular Design:** Separate environments for Networking, Source DB, and Migration Logic.

---

## 🏗 Architecture
The project is structured into logical modules to simulate a real-world multi-tier environment:

* **`test1/` (Source Environment):** VPC networking, public subnets, and the Source RDS MySQL instance.
* **`test2/` (Target Environment):** The destination RDS instance, configured to receive the migrated schema.
* **`dms/` (Migration Layer):** The DMS Replication Instance, source/target endpoints, and the replication task.



---

## 🛠 Technical Stack
* **Cloud Provider:** AWS (Global Infrastructure)
* **IaC Tool:** Terraform (v1.x+)
* **Engine:** MySQL 8.0
* **Migration Service:** AWS DMS (Instance Class: `dms.t3.small`)

---

## 🚀 Execution Workflow

### 1. Initialization & Security
Ensure your `.gitignore` is present in the root folder to protect `.tfstate` files and sensitive variables.

### 2. Infrastructure Deployment
Navigate to each directory and apply the configuration in sequence:
```bash
# Deploy Network & Source Database
cd test1 && terraform init && terraform apply -auto-approve

# Deploy Target Database
cd ../test2 && terraform init && terraform apply -auto-approve

# Deploy Migration Service & Start Task
cd ../dms && terraform init && terraform apply -auto-approve

```
## 3. Connectivity & Security Architecture
### Direct-to-RDS Access (Development Workflow)
Unlike a traditional production environment that uses a **Bastion Host (Jump Box)**, this project utilizes a **Direct Connectivity Model** for the development phase. 

* **MySQL Workbench Integration:** The Source and Target RDS instances are configured with `Publicly Accessible = true` and restricted Security Groups, allowing for direct schema modeling and data seeding via MySQL Workbench from a local environment.
* **Why this choice?** This architecture minimizes operational overhead and cost during the POC (Proof of Concept) phase while ensuring the **DMS Replication Instance** remains the primary engine for high-volume data transfer.
* **Network Handshake:** The Security Groups are strictly scoped to allow ingress only from the developer's specific IP and the DMS Replication Instance ID.

### 4. Data Validation

Connect to the Source RDS via MySQL Workbench, seed the `OnlineMerchStore` data, and monitor the **DMS Table Statistics** console to verify 100% row migration to the target instance.

---

## 🔍 Engineering Highlights

* **Task Mapping:** JSON-based object-mapping to selectively migrate the e-commerce schema.
* **Endpoint Authentication:** Secured connection strings via Terraform sensitive variables.
* **Performance Tuning:** Configured `dms.t3.small` instances to handle transaction log (BinLog) caching during Full Load phases.

---

**Author:** [AlambaJnr]
**Portfolio:** [www.linkedin.com/in/collinsuket]

```

---

