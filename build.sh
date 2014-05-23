#!/bin/bash

set -e

case $1 in
  "precise")
    packer build packer/precise.json
    ;;
  "precise-full")
    packer build packer/precise-full.json
    ;;
  "bebanjo-vexor")
    PACKER_LOG=1 packer build packer/bebanjo-vexor.json
    ;;
  *)
    echo "Usage $0 (precise|precise-full|bebanjo-vexor)"
    exit 1
    ;;
esac
