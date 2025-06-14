#!/bin/sh -eu

# Note: this script is only run once when the postgres volume is created. To
# run it again:
#
#     docker volume rm srht-containers_postgres-data

password='$2b$12$mlcAuUeU5reidsdPcZm/kOR4EWkZE2lbMvyVSHLpDuzDtm6MGn0Ne'
client_secret='3eeeef2fd9d1e0176a50ee76d3382f7211231b832852bdfc3569a3bb5512158a19b1262b73ea735059004fd3ded53303e42f605e68ccbc9d3af84a373331aa9d'
token='26eefba4ba6fb3c98123e37fcf18018c91b4f17f14b1cb124a1ad0e99b52674e59dd3ee52d1b13cb1aebef444877fe3abb072937684214817919231302dd0d33'

createdb meta.sr.ht
psql -d meta.sr.ht </data/meta.sr.ht.sql
psql -d meta.sr.ht <<EOF
INSERT INTO "user" (id, created, updated, username, password, email, user_type)
VALUES (1, NOW(), NOW(), 'root', '$password', 'root@localhost', 'ADMIN');
EOF

createdb todo.sr.ht
psql -d todo.sr.ht </data/todo.sr.ht.sql

createdb git.sr.ht
psql -d git.sr.ht </data/git.sr.ht.sql

createdb man.sr.ht
psql -d man.sr.ht </data/man.sr.ht.sql

createdb paste.sr.ht
psql -d paste.sr.ht </data/paste.sr.ht.sql
