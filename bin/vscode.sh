#!/bin/bash
# Bash script installing vscode.
#
# Author: Cameron Rollheiser <icirellik@gmail.com>

set -e

curl -sSLo vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868

sudo dpkg -i vscode.deb

rm vscode.deb
