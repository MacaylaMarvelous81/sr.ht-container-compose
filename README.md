# sr.ht-containers

The first time sr.ht-containers is used, sr.ht sources need to be cloned
locally:

    make init

Then sr.ht can be built and started:

    docker compose watch

Any changes to the sr.ht sources will rebuild and reload sr.ht containers as
needed.

A default admin "root" is created, with password "root".
