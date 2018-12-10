FROM alpine:latest
LABEL maintainer="gwaewion@gmail.com"
EXPOSE 22 3000
VOLUME /data
COPY run.sh /root

ENV USERNAME gogs
ENV USERHOME /gogs
ENV PASSWORD password

RUN apk update && apk add git curl openssh-server alpine-sdk go && \
	ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
	ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa && \
	ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa && \
	ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519  && \
	adduser -D -h $USERHOME $USERNAME  && \
	echo -e "$PASSWORD\r$PASSWORD" | passwd $USERNAME  && \
	su - $USERNAME -c "go get -u github.com/gogs/gogs"  && \
	su - $USERNAME -c "cd $USERHOME/go/src/github.com/gogs/gogs && go build"  && \
	apk del alpine-sdk go && \
	cp -R $USERHOME/go/src/github.com/gogs/gogs/gogs $USERHOME/go/src/github.com/gogs/gogs/public/ $USERHOME/go/src/github.com/gogs/gogs/scripts/ $USERHOME/go/src/github.com/gogs/gogs/templates/ $USERHOME && \
	cd / && rm -rf $USERHOME/go && \
	chown -R $USERNAME:$USERNAME $USERHOME

CMD ["sh", "/root/run.sh"]