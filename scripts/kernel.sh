#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
shopt -s nullglob
shopt -s nocaseglob

sudo apt install --install-recommends linux-generic-hwe-18.04