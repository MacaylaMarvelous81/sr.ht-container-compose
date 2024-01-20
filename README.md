# sr.ht-containers

The first time sr.ht-containers is used, sr.ht sources need to be cloned
locally:

    make init

Then sr.ht can be built and started:

    docker compose watch

Any changes to the sr.ht sources will rebuild and reload sr.ht containers as
needed.

A default admin "root" is created, with password "root".

The following services are included:

- meta.sr.ht: web frontend at http://127.0.0.1:5000
- todo.sr.ht: web frontend at http://127.0.0.1:5003
- git.sr.ht: web frontend at http://127.0.0.1:5001,
  SSH access at ssh://git@127.0.0.1:5922
