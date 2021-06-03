Bitcoin Cash Daemon for Docker
===================

[![Docker Stars](https://img.shields.io/docker/stars/mahsumurebe/bitcoin-cash.svg)](https://hub.docker.com/r/mahsumurebe/bitcoin-cash/)
[![Docker Pulls](https://img.shields.io/docker/pulls/mahsumurebe/bitcoin-cash.svg)](https://hub.docker.com/r/mahsumurebe/bitcoin-cash/)
[![Build Status](https://travis-ci.org/mahsumurebe/docker-bch-bitcoind.svg?branch=master)](https://travis-ci.org/mahsumurebe/docker-bch-bitcoind/)
[![ImageLayers](https://images.microbadger.com/badges/image/mahsumurebe/bitcoin-cash.svg)](https://microbadger.com/#/images/mahsumurebe/bitcoin-cash)

Docker image that runs the Bitcoin Bitcoin Cash node in a container for easy deployment.


Requirements
------------

* Physical machine, cloud instance, or VPS that supports Docker (i.e. Hetzner, Vultr, Digital Ocean, KVM or XEN based VMs) running Ubuntu 14.04 or later (*not OpenVZ containers!*)
* At least 100 GB to store the block chain files (and always growing!)
* At least 1 GB RAM + 2 GB swap file

Really Fast Quick Start
-----------------------

One liner for Ubuntu 14.04 LTS machines with JSON-RPC enabled on localhost and adds upstart init script:

    curl https://raw.githubusercontent.com/mahsumurebe/docker-bch-bitcoind/master/bootstrap-host.sh | sh -s trusty


Quick Start
-----------

1. Create a `bitcoin-cash-data` volume to persist the Bitcoin Cash Daemon blockchain data, should exit immediately.  The `bitcoin-cash-data` container will store the blockchain when the node container is recreated (software upgrade, reboot, etc):

        docker volume create --name=bitcoin-cash-data
        docker run -v bitcoin-cash-data:/bitcoin/.bitcoin --name=bitcoin-cash-node -d \
            -p 8333:8333 \
            -p 127.0.0.1:8332:8332 \
            mahsumurebe/bitcoin-cash

2. Verify that the container is running and Bitcoin Cash node is downloading the blockchain

        $ docker ps
        CONTAINER ID        IMAGE                               COMMAND             CREATED             STATUS              PORTS                                              NAMES
        d0e1076b2dca        mahsumurebe/bitcoin-cash:latest     "btc_oneshot"       2 seconds ago       Up 1 seconds        127.0.0.1:8332->8332/tcp, 0.0.0.0:8333->8333/tcp   bitcoin-cash-node

3. You can then access the daemon's output thanks to the [docker logs command]( https://docs.docker.com/reference/commandline/cli/#logs)

        docker logs -f bitcoin-cash-node

4. Install optional init scripts for upstart and systemd are in the [init](./init) directory.


Documentation
-------------

* Additional documentation in the [docs folder](docs).
