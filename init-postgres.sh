#!/bin/sh -eu

# Note: this script is only run once when the postgres volume is created. To
# run it again:
#
#     docker volume rm srht-containers_postgres-data

password='$2b$12$mlcAuUeU5reidsdPcZm/kOR4EWkZE2lbMvyVSHLpDuzDtm6MGn0Ne'
client_secret='3eeeef2fd9d1e0176a50ee76d3382f7211231b832852bdfc3569a3bb5512158a19b1262b73ea735059004fd3ded53303e42f605e68ccbc9d3af84a373331aa9d'
createdb meta.sr.ht
psql -d meta.sr.ht </data/meta.sr.ht.sql
psql -d meta.sr.ht <<EOF
INSERT INTO "user" (id, created, updated, username, password, email, user_type)
VALUES (1, NOW(), NOW(), 'root', '$password', 'root@localhost', 'admin');
INSERT INTO oauthclient (created, updated, user_id, client_name, client_id, client_secret_hash, client_secret_partial, redirect_uri, preauthorized)
VALUES (NOW(), NOW(), 1, 'todo.sr.ht', 'todo', '$client_secret', '3387e161', 'http://127.0.0.1:5003/oauth/callback', TRUE);
EOF

createdb todo.sr.ht
psql -d todo.sr.ht </data/todo.sr.ht.sql
