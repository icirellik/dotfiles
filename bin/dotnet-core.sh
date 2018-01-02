#!/bin/bash
# Bash script installing dotnet core.
#
# Author: Cameron Rollheiser <icirellik@gmail.com>

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list'

sudo apt-get update
sudo apt-get install -y dotnet-sdk-2.1.3

# Install VSCode Extension
curl -sLo /tmp/vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868
sudo dpkg -i /tmp/vscode.deb
rm /tmp/vscode.deb

# Install C# VSCode Extension
code --install-extension ms-vscode.csharp