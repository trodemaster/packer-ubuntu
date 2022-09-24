# packer-ubuntu
This packer template currently builds Ubuntu 22.04 for arm64 with VMware Fusion. 

# Prerequsits
macOS running on an applesilicon Mac
Packer 1.8.x
VMware Fusion Tech Preview
# Building
Customize the build variables
```
cp ubuntu.auto.EXAMPLE.hcl ubuntu.auto.pkrvars.hcl
```

Edit the ubuntu.auto.pkrvars.hcl file and populate the values as needed. Once the values are populated you can run the build script. 

```
./build
```

# Eratta
As a workaround to current compatability issues the .iso is sourced from the jammy daily pending branch. Graphics will not be displayed until after the system reboots with a newer kernel that is installed late in the build process. 