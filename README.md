# Terraform VPC Demo

## Overview

This project demonstrates how to provision a complete public network infrastructure in AWS using Terraform.

The infrastructure includes:

* Custom VPC
* Public Subnet
* Internet Gateway
* Route Table
* Route Table Association
* Security Group
* EC2 Instance

The goal of this project is to understand how AWS networking components work together to make an EC2 instance accessible from the internet.

---

## Architecture

Internet

↓

Internet Gateway

↓

Route Table (0.0.0.0/0)

↓

Public Subnet (10.0.1.0/24)

↓

EC2 Instance

---

## Resources Created

### 1. VPC

```hcl
resource "aws_vpc" "main"
```

**Purpose**

A VPC (Virtual Private Cloud) is a logically isolated network in AWS.

CIDR:

```text
10.0.0.0/16
```

The VPC provides the overall IP address space for all subnets and resources inside it.

Without a VPC, no networking resources can be created.

---

### 2. Public Subnet

```hcl
resource "aws_subnet" "public"
```

CIDR:

```text
10.0.1.0/24
```

**Purpose**

A subnet is a smaller network created inside a VPC.

AWS launches EC2 instances into subnets, not directly into VPCs.

The subnet receives a portion of the VPC's address space.

---

### 3. Internet Gateway

```hcl
resource "aws_internet_gateway" "igw"
```

**Purpose**

Provides a connection between the VPC and the public internet.

Without an Internet Gateway:

* EC2 instances cannot access the internet
* Internet users cannot reach the EC2 instance

Think of it as the main gate connecting the VPC to the outside world.

---

### 4. Route Table

```hcl
resource "aws_route_table" "public"
```

Route:

```text
0.0.0.0/0 -> Internet Gateway
```

**Purpose**

A route table controls how traffic leaves a subnet.

Route explanation:

```text
0.0.0.0/0
```

means:

"Any destination on the internet"

This route tells AWS:

```text
Send all internet traffic
through the Internet Gateway
```

Without this route, traffic has no path to the internet.

---

### 5. Route Table Association

```hcl
resource "aws_route_table_association" "public"
```

**Purpose**

Associates the route table with the subnet.

Without this association:

* The route table exists
* The subnet exists
* But AWS does not know which subnet should use the route table

This association makes the subnet a Public Subnet.

---

### 6. Security Group

```hcl
resource "aws_security_group" "web_sg"
```

**Purpose**

Acts as a virtual firewall for the EC2 instance.

Inbound Rule:

```text
TCP 22
Source: 0.0.0.0/0
```

Allows SSH access from any location.

Outbound Rule:

```text
All Traffic
0.0.0.0/0
```

Allows the instance to initiate outbound connections.

Without a Security Group, network access to the instance would be restricted.

---

### 7. EC2 Instance

```hcl
resource "aws_instance" "web"
```

**Purpose**

Represents the virtual server running inside the public subnet.

Instance Type:

```text
t3.micro
```

The EC2 instance receives networking configuration from the subnet and security group.

---

## Why associate_public_ip_address = true ?

```hcl
associate_public_ip_address = true
```

**Purpose**

Assigns a Public IPv4 address to the EC2 instance.

Without a public IP:

```text
Internet Gateway      ✓
Route Table           ✓
Public Subnet         ✓
```

Even with all of the above configured correctly, users on the internet cannot directly reach the EC2 instance.

The instance would only have a private IP address such as:

```text
10.0.1.x
```

which is not routable from the public internet.

With:

```hcl
associate_public_ip_address = true
```

AWS assigns a public IP address, making the instance reachable from outside the VPC (subject to security group rules).

---

## Terraform Concepts Demonstrated

* Resource Dependencies
* AWS Networking
* VPC Design
* Subnet Design
* Internet Connectivity
* Route Tables
* Security Groups
* EC2 Provisioning
* Infrastructure as Code (IaC)

---

## Learning Outcomes


* How VPCs and Subnets relate to each other
* Why EC2 instances must be launched inside a subnet
* How Internet Gateways provide internet connectivity
* How Route Tables control traffic flow
* Why Route Table Associations are required
* How Security Groups protect EC2 instances
* Why Public IP assignment is necessary for internet accessibility
* How Terraform automatically manages resource dependencies

---

## Cleanup

To remove all resources:

```bash
terraform destroy
```

Terraform automatically destroys resources in the correct dependency order.
