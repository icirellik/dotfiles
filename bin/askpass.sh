#!/bin/bash

# Bash script silently prompting for a password.
#
# Author: Cameron Rollheiser <icirellik@gmail.com>

echo -n "$*: " >/dev/stderr
stty -echo
read -r answer
stty echo
echo "$answer"
