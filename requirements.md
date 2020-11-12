# Docker and Docker Compose Installation on Ubuntu 16.04

## Repository Setup

1. Update the apt package index and install basic packages
   ```
   sudo apt-get update
   sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
   ```
2. Add GPG key

   ```
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
   ```

3. Setup stable repository

   ```
   sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
   ```

## Install Docker

1. install docker engine

   ```
   sudo apt-get update
   sudo apt-get install docker-ce docker-ce-cli containerd.io
   ```

2. add used to Docker group

   ```
   sudo usermod -aG docker ${USER}
   ```

# Install Docker Compose

1. Download stable release

   ```
   sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   ```

2. Make file executable

   ```
   sudo chmod +x /usr/local/bin/docker-compose
   ```
