# Copy to ubuntu.auto.pkrvars.hcl and set values. Used by: packer build -var-file=ubuntu.auto.pkrvars.hcl .

fusion_app_path = "/Applications/VMware Fusion.app"
user_password    = "ubuntu123!"
# Generate hash: openssl passwd -6 -salt $(openssl rand -hex 4) 'yourpassword'
user_password_hash = "generated password hash"
user_username     = "ubuntu"
hostname          = "ubuntu2510"
os_version        = "25.10"
ssh_key           = "your public ssh key"

# Optional overrides (defaults in ubuntu.pkr.hcl)
# guest_os_type = "ubuntu-64"
# cpu_count     = "6"
# ram_gb        = "16"
# disk_gb       = "30"
