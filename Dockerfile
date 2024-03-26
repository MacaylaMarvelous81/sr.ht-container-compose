FROM docker.io/alpine:3.19 as srht-core
RUN mkdir -p /var/cache/apk && ln -s /var/cache/apk /etc/apk/cache
RUN --mount=type=cache,target=/var/cache/apk \
	apk -U add curl
RUN echo "https://mirror.sr.ht/alpine/v3.19/sr.ht" >>/etc/apk/repositories
RUN curl -o /etc/apk/keys/alpine@sr.ht.rsa.pub 'https://mirror.sr.ht/alpine/alpine%40sr.ht.rsa.pub'
RUN --mount=type=cache,target=/var/cache/apk \
	apk -U add py3-srht
ADD core.sr.ht /src/core.sr.ht/
ENV SRHT_PATH=/src/core.sr.ht/srht
ENV PYTHONPATH=/src/core.sr.ht
ENV PATH="${PATH}:/src/core.sr.ht"

FROM srht-core as srht-core-build
RUN --mount=type=cache,target=/var/cache/apk \
	apk -U add go make sassc minify

FROM srht-core-build as srht-meta-build
ADD meta.sr.ht /src/meta.sr.ht/
RUN --mount=type=cache,target=/root/.cache/go-build \
	--mount=type=cache,target=/root/go/pkg/mod \
	cd /src/meta.sr.ht && make

FROM srht-core-build as srht-todo-build
ADD todo.sr.ht /src/todo.sr.ht/
RUN --mount=type=cache,target=/root/.cache/go-build \
	--mount=type=cache,target=/root/go/pkg/mod \
	cd /src/todo.sr.ht && make

FROM srht-core-build as srht-git-build
ADD git.sr.ht /src/git.sr.ht/
ADD scm.sr.ht /src/scm.sr.ht/
RUN --mount=type=cache,target=/root/.cache/go-build \
	--mount=type=cache,target=/root/go/pkg/mod \
	cd /src/git.sr.ht && make

FROM srht-core-build as srht-paste-build
ADD paste.sr.ht /src/paste.sr.ht/
RUN --mount=type=cache,target=/root/.cache/go-build \
	--mount=type=cache,target=/root/go/pkg/mod \
	cd /src/paste.sr.ht && make

FROM srht-core as srht-meta
RUN --mount=type=cache,target=/var/cache/apk \
	apk -U add meta.sr.ht
COPY --from=srht-meta-build /src/meta.sr.ht /src/meta.sr.ht
ENV PYTHONPATH="${PYTHONPATH}:/src/meta.sr.ht"
ENV PATH="${PATH}:/src/meta.sr.ht"

FROM srht-core as srht-todo
RUN --mount=type=cache,target=/var/cache/apk \
	apk -U add todo.sr.ht
COPY --from=srht-todo-build /src/todo.sr.ht /src/todo.sr.ht
ENV PYTHONPATH="${PYTHONPATH}:/src/todo.sr.ht"
ENV PATH="${PATH}:/src/todo.sr.ht"

FROM srht-core as srht-git
RUN --mount=type=cache,target=/var/cache/apk \
	apk -U add git.sr.ht openssh
ADD scm.sr.ht /src/scm.sr.ht/
COPY --from=srht-git-build /src/git.sr.ht /src/git.sr.ht
RUN passwd -u git # Unlock account to allow SSH login
ENV PYTHONPATH="${PYTHONPATH}:/src/scm.sr.ht:/src/git.sr.ht"
ENV PATH="${PATH}:/src/git.sr.ht"

FROM srht-core as srht-paste
RUN --mount=type=cache,target=/var/cache/apk \
	apk -U add paste.sr.ht
COPY --from=srht-paste-build /src/paste.sr.ht /src/paste.sr.ht
ENV PYTHONPATH="${PYTHONPATH}:/src/paste.sr.ht"
ENV PATH="${PATH}:/src/paste.sr.ht"
