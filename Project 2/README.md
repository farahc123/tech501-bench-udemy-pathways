![Terraform S3 backend initialised](image.png)

![created ec2s](image-4.png)

![created VPC](image-5.png)

![created ASG](image-6.png)

![launch template](image-7.png)

![ansible playbook run](image-8.png)

![app running on app instance 1](image-2.png)

![app running on app instance 2](image-1.png)

![same posts page on both apps](image-3.png)

![adding tag to test versioning](image-9.png)

![new version of tfstate file](image-10.png)

## Steps for setup in GCP

- need to add playbook tasks to install Git and Nano
- need to add the SSH key to project-wide metadata for the compute engines so that the Ansible controller can SSH in
- if you get with a `WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!` error after previously successfully SSHing into a target VM from the Ansible controller, run `ssh-keygen -f "/home/fcheded/.ssh/known_hosts" -R "35.233.85.9"` (change IP to that of the target VM) and try again