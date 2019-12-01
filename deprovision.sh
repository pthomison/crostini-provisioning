#!/usr/bin/env bash

VM_NAME=$1

lxc stop $VM_NAME --force
lxc delete $VM_NAME
