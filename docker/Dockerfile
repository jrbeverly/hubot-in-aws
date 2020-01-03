FROM node:lts

COPY docker/pkg/apt /tmp/apt
RUN apt-get update \
    && xargs -a /tmp/apt apt-get install --no-install-recommends -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/*

RUN pip3 install --upgrade setuptools && pip3 install --quiet awscli --upgrade

COPY docker/rootfs/ /
RUN chmod +x /usr/bin/hubot

COPY src/ /hubot/
WORKDIR /hubot/
RUN npm install -g coffeescript ; npm install
CMD ["hubot"]