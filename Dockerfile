FROM docker.io/alpine:3.17 as sr.ht
RUN apk add curl socat
RUN echo "https://mirror.sr.ht/alpine/v3.17/sr.ht" >>/etc/apk/repositories
RUN curl -o /etc/apk/keys/alpine@sr.ht.rsa.pub 'https://mirror.sr.ht/alpine/alpine%40sr.ht.rsa.pub'
RUN apk update
ADD core.sr.ht /src/core.sr.ht/
ENV SRHT_PATH=/src/core.sr.ht/srht
ENV PYTHONPATH=/src/core.sr.ht

FROM sr.ht as sr.ht-build
RUN apk add go make sassc minify

FROM sr.ht-build as meta.sr.ht-build
ADD meta.sr.ht /src/meta.sr.ht/
RUN --mount=type=cache,target=/root/.cache/go-build \
	--mount=type=cache,target=/root/go/pkg/mod \
	cd /src/meta.sr.ht && make

FROM sr.ht-build as todo.sr.ht-build
ADD todo.sr.ht /src/todo.sr.ht/
RUN --mount=type=cache,target=/root/.cache/go-build \
	--mount=type=cache,target=/root/go/pkg/mod \
	cd /src/todo.sr.ht && make

FROM sr.ht as meta.sr.ht
RUN apk add meta.sr.ht
COPY --from=meta.sr.ht-build /src/meta.sr.ht /src/meta.sr.ht
ENV PYTHONPATH="${PYTHONPATH}:/src/meta.sr.ht"
ENV PATH="${PATH}:/src/meta.sr.ht"

FROM sr.ht as todo.sr.ht
RUN apk add todo.sr.ht
COPY --from=todo.sr.ht-build /src/todo.sr.ht /src/todo.sr.ht
ENV PYTHONPATH="${PYTHONPATH}:/src/todo.sr.ht"
ENV PATH="${PATH}:/src/todo.sr.ht"
