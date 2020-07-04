#!/usr/bin/env bash

VM_NAME=penguin

lxc stop $VM_NAME --force
lxc delete $VM_NAME
