#!/bin/bash

set -e

case $1 in
  "precise")
    packer build packer/docker/precise.json
    ;;
  "precise-full")
    packer build packer/docker/precise-full.json
    ;;
  "precise-bebanjo")
    packer build packer/docker/precise-bebanjo.json
    ;;
  *)
    echo "Usage $0 (precise|precise-full|precise-bebanjo)"
    exit 1
    ;;
esac
