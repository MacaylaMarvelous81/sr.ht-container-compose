FROM docker.io/alpine:3.17 as sr.ht
RUN apk add curl
RUN echo "https://mirror.sr.ht/alpine/v3.17/sr.ht" >>/etc/apk/repositories
RUN curl -o /etc/apk/keys/alpine@sr.ht.rsa.pub 'https://mirror.sr.ht/alpine/alpine%40sr.ht.rsa.pub'
RUN apk update

FROM sr.ht as meta.sr.ht
RUN apk add meta.sr.ht
