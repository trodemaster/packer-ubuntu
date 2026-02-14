# Packer Ubuntu VM build (VMware Fusion)

BUILD_NAME   := vmware-iso
OS_VERSION   := 25.10
VM_OUTPUT    := output/$(BUILD_NAME)_$(OS_VERSION)
VMX_PATH     := $(CURDIR)/$(VM_OUTPUT)/$(BUILD_NAME)_$(OS_VERSION).vmx
VMRUN        := "/Applications/VMware Fusion.app/Contents/Library/vmrun"
LEASES_FILE  := /var/db/vmware/vmnet-dhcpd-vmnet8.leases

.PHONY: all clean flushdhcp help

all:
	packer init .
	packer build .

help:
	@echo "Packer Ubuntu VM (VMware Fusion)"
	@echo ""
	@echo "Targets:"
	@echo "  make          - run packer init and build"
	@echo "  make clean    - stop any running VM under output/ via vmrun, then delete output/"
	@echo "  make flushdhcp - quit VMware Fusion, then flush vmnet8 DHCP leases (first 7 lines; requires sudo)"
	@echo "  make help     - show this help"
	@echo ""

clean:
	@echo "==> Stopping any running VMs under output/..."
	@$(VMRUN) list 2>/dev/null | tail -n +2 | while read vmx; do \
		vmx="$$(echo "$$vmx" | tr -d '\r')"; \
		if [ -n "$$vmx" ] && [ -f "$$vmx" ] && echo "$$vmx" | grep -q "$(CURDIR)/output/"; then \
			echo "==> Stopping $$vmx"; \
			$(VMRUN) stop "$$vmx" hard || true; \
			sleep 2; \
		fi; \
	done
	@echo "==> Removing output/..."
	@rm -rf output
	@echo "==> Done."

# Flush VMware vmnet8 DHCP leases: replace file with first 7 lines only (header, no brace).
# Requires sudo. Safe: writes to a temp file then moves into place.
flushdhcp:
	@echo "==> Quitting VMware Fusion..."
	@osascript -e 'tell application "VMware Fusion" to quit' || true
	@sleep 2
	@LEASES="$(LEASES_FILE)"; \
	if ! sudo test -f "$$LEASES"; then echo "==> Error: $$LEASES not found"; exit 1; fi; \
	lines=$$(sudo wc -l < "$$LEASES" | tr -d ' '); \
	if [ "$$lines" -lt 7 ]; then echo "==> Error: file must have at least 7 lines (has $$lines)"; exit 1; fi; \
	TMP=$$(mktemp); \
	trap "rm -f $$TMP" EXIT; \
	sudo head -n 7 "$$LEASES" > "$$TMP"; \
	sudo mv "$$TMP" "$$LEASES"; \
	trap - EXIT; \
	echo "==> Flushed DHCP leases (first 7 lines only)."
