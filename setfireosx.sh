#!/bin/bash

echo " Enable OSX : Firewall"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw \
  --setblockall off \
  --setallowsigned on \
  --setallowsignedapp on \
  --setloggingmode on \
  --setstealthmode off \
  --setglobalstate on
