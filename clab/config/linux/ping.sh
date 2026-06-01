#!/bin/bash

printf "\n##### Ping s1-host1 #####\n"
fping s1-host1 -c 2 -A

printf "\n##### Ping s1-host2 #####\n"
fping s1-host2 -c 2 -A

printf "\n##### Ping s1-host3 #####\n"
fping s1-host3 -c 2 -A

printf "\n##### Ping s1-host4 #####\n"
fping s1-host4 -c 2 -A

printf "\n##### Ping s2-host1 #####\n"
fping s2-host1 -c 2 -A

printf "\n##### Ping s2-host2 #####\n"
fping s2-host2 -c 2 -A