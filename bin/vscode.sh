#!/bin/bash
# Bash script installing vscode.
#
# Author: Cameron Rollheiser <icirellik@gmail.com>

set -e

curl -sSLo vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868

sudo dpkg -i vscode.deb

rm vscode.deb

# Install extensions.
code --install-extension dbaeumer.vscode-eslint
code --install-extension eriklynd.json-tools
code --install-extension ms-python.python
