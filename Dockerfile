FROM mhart/alpine-node:13.8.0

RUN apk update && apk add --no-cache --virtual build-dependencies git python g++ make
RUN wget https://github.com/ethereum/solidity/releases/download/v0.5.17/solc-static-linux -O /bin/solc && chmod +x /bin/solc

RUN mkdir -p /benqi-protocol
WORKDIR /benqi-protocol

# First add deps
ADD ./package.json /benqi-protocol
ADD ./yarn.lock /benqi-protocol
RUN yarn install --lock-file

# Then rest of code and build
ADD . /benqi-protocol

ENV SADDLE_SHELL=/bin/sh
ENV SADDLE_CONTRACTS="contracts/*.sol contracts/**/*.sol"
RUN npx saddle compile

RUN apk del build-dependencies
RUN yarn cache clean

CMD while :; do sleep 2073600; done
