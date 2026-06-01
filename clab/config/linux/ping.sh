#!/bin/bash

printf "\n##### Ping s1-host1 #####\n"
ip vrf exec vrf_prod fping s1-host1 -c 2

printf "\n##### Ping s1-host2 #####\n"
ip vrf exec vrf_prod fping s1-host2 -c 2

printf "\n##### Ping s1-host3 #####\n"
ip vrf exec vrf_prod fping s1-host3 -c 2

printf "\n##### Ping s1-host4 #####\n"
ip vrf exec vrf_prod fping s1-host4 -c 2

printf "\n##### Ping s2-host1 #####\n"
ip vrf exec vrf_prod fping s2-host1 -c 2

printf "\n##### Ping s2-host2 #####\n"
ip vrf exec vrf_prod fping s2-host2 -c 2