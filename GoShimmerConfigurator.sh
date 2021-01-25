#!/bin/bash

goshimmerPath=/opt/goshimmer

# Create goshimmer folder and change access to DB folder to 777
mkdir -p $goshimmerPath/db && chmod 0777 $goshimmerPath/db

cat >/$goshimmerPath/docker-compose.yml <<EOL
version: '3.3'

networks:
  outside:
    external:
      name: shimmer

services:
  goshimmer:
    image: iotaledger/goshimmer:latest
    container_name: goshimmer
    hostname: goshimmer
    stop_grace_period: 1m
    restart: unless-stopped
    volumes:
      - "./db:/tmp/mainnetdb:rw"   
      - "/etc/localtime:/etc/localtime:ro"
    ports:
      # Autopeering 
      - "0.0.0.0:14626:14626/udp"
      # Gossip
      - "0.0.0.0:14666:14666/tcp"
      # FPC
      - "0.0.0.0:10895:10895/tcp"
      # HTTP API
      - "0.0.0.0:8080:8080/tcp"
      # Dashboard
      - "0.0.0.0:8081:8081/tcp"
      # pprof profiling
      # - "0.0.0.0:6061:6061/tcp" # DISABLED
    environment:
      - ANALYSIS_CLIENT_SERVERADDRESS=ressims.iota.cafe:21888
      - AUTOPEERING_PORT=14626
      - DASHBOARD_BINDADDRESS=0.0.0.0:8081
      - GOSSIP_PORT=14666
      - WEBAPI_BINDADDRESS=0.0.0.0:8080
      # - PROFILING_BINDADDRESS=0.0.0.0:6061 # DISABLED
      - NETWORKDELAY_ORIGINPUBLICKEY=9DB3j9cWYSuEEtkvanrzqkzCQMdH1FGv3TawJdVbDxkd
      - FPC_BINDADDRESS=0.0.0.0:10895
      # - PROMETHEUS_BINDADDRESS=0.0.0.0:9311 # DISABLED
    command: >
      --skip-config=true
      --autopeering.entryNodes=2PV5487xMw5rasGBXXWeqSi4hLz7r19YBt8Y1TGAsQbj@ressims.iota.cafe:15626,5EDH4uY78EA6wrBkHHAVBWBMDt7EcksRq6pjzipoW15B@entrynode.alphanet.einfachiota.de:14656
      --node.disablePlugins=prometheus, remotelog
      --node.enablePlugins=networkdelay,spammer
      --logger.level=info
      --logger.disableEvents=false
      --logger.remotelog.serverAddress=ressims.iota.cafe:5213
      --drng.pollen.instanceId=1
      --drng.pollen.threshold=3
      --drng.pollen.committeeMembers=AheLpbhRs1XZsRF8t8VBwuyQh9mqPHXQvthV5rsHytDG,FZ28bSTidszUBn8TTCAT9X1nVMwFNnoYBmZ1xfafez2z,GT3UxryW4rA9RN9ojnMGmZgE2wP7psagQxgVdA4B9L1P,4pB5boPvvk2o5MbMySDhqsmC2CtUdXyotPPEpb7YQPD7,64wCsTZpmKjRVHtBKXiFojw7uw3GszumfvC4kHdWsHga
      --drng.xteam.instanceId=1339
      --drng.xteam.threshold=4
      --drng.xteam.committeeMembers=GUdTwLDb6t6vZ7X5XzEnjFNDEVPteU7tVQ9nzKLfPjdo,68vNzBFE9HpmWLb2x4599AUUQNuimuhwn3XahTZZYUHt,Dc9n3JxYecaX3gpxVnWb4jS3KVz1K1SgSK1KpV1dzqT1,75g6r4tqGZhrgpDYZyZxVje1Qo54ezFYkCw94ELTLhPs,CN1XLXLHT9hv7fy3qNhpgNMD6uoHFkHtaNNKyNVCKybf,7SmttyqrKMkLo5NPYaiFoHs8LE6s7oCoWCQaZhui8m16,CypSmrHpTe3WQmCw54KP91F5gTmrQEL7EmTX38YStFXx
    networks:
      - outside
EOL
