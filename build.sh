#!/bin/bash

set -e

case $1 in
  "precise")
    packer build packer/precise.json
    ;;
  "precise-full")
    packer build packer/precise-full.json
    ;;
  "precise-vexor")
    PACKER_LOG=1 packer build packer/precise-full-vexor.json
    ;;
  *)
    echo "Usage $0 (precise|precise-full|precise-vexor)"
    exit 1
    ;;
esac
