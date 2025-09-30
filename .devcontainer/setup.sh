#!/bin/bash

bash -c "$(curl -sL https://get.containerlab.dev)" -- -v 0.70.2
pip3 install passlib
ssh-keygen -t ecdsa -f ~/.ssh/id_ecdsa -q -N ""
ansible-galaxy collection install ansible.posix
sudo usermod -aG clab_admins $USER && newgrp clab_admins
