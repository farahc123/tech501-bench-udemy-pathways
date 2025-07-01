This directory contains the Terraform code for provisioning the infrastructure required for the 2-tier app in modular form. It makes use of a Managed Instance Group to auto-scale the app VMs.

It also contains Python scripts that are used in the `metadata` section of the VM & MIG `main.tf` files. Images can then be made of these machines.