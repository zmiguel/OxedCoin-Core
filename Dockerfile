FROM ubuntu:16.04

COPY ./oxedcoin.conf /root/.oxedcoin/oxedcoin.conf

COPY . /oxedcoin
WORKDIR /oxedcoin

#shared libraries and dependencies
RUN apt update
RUN apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils bsdmainutils python3
RUN apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev libssl-dev libevent-dev 

#BerkleyDB for wallet support
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install -y libdb4.8-dev libdb4.8++-dev

#upnp
RUN apt-get install -y libminiupnpc-dev

#ZMQ
RUN apt-get install -y libzmq3-dev

#build oxedcoin source
RUN chmod +x /oxedcoin/autogen.sh
RUN ./autogen.sh
RUN ./configure --disable-wallet --without-gui --without-miniupnpc
RUN make
RUN make install

#open service port
EXPOSE 9333 19333

CMD ["oxedcoind", "--printtoconsole"]