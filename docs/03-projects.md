---
layout: default
title: AAP Project Config
nav_order: 3
has_children: false
---

# Create the project for this Repository

In Automation Controller/AWX projects a
re used to connect it to a version control system containing the artifacts for your automation.

1. Click on `Resources` -> `Projects`
2. Click on `Add` and enter the following parameters
   - **Name**:  SAP Demo Install
   - **Description**: _Optional_
   - **Organization**: _Select the organization you run this use case in_
   - **Source Control Type**: Select GIT
   - **Source Control URL**: https://github.com/sap-linuxlab/demo.sap_install
  
  You can leave the other fields  empty