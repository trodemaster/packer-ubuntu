#!/bin/sh
sudo /bin/rm -rf /tmp/*
sudo dd if=/dev/zero of=/EMPTY bs=10M
sudo rm -f /EMPTY
sudo sync

exit 0
