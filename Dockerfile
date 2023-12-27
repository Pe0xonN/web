# Download git repo
FROM ubuntu AS git-download
RUN apt-get update && apt-get install -y git
WORKDIR /app
RUN git clone https://github.com/divyam234/rclone.git .


# Build rclone
FROM golang AS rclone-builder

COPY --from=git-download /app /go/src/github.com/rclone/rclone/
WORKDIR /go/src/github.com/rclone/rclone/

RUN \
  CGO_ENABLED=0 \
  make
RUN ./rclone version


# Running Container
FROM ubuntu

WORKDIR /app

RUN apt update && apt install curl  unzip -y 

## Get rclone from builder
COPY --from=rclone-builder /go/src/github.com/rclone/rclone/rclone /usr/local/bin/

RUN useradd -m -u 1000 user

USER user

ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH

RUN mkdir -p $HOME/.local/bin

WORKDIR $HOME/app

COPY --chown=user . $HOME/app

RUN rclone version

EXPOSE 7860

RUN chmod 755 ./docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]