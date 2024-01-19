#!/bin/sh -eu

createdb meta.sr.ht
psql -d meta.sr.ht </data/meta.sr.ht.sql
psql -d meta.sr.ht <<'EOF'
INSERT INTO "user" (id, created, updated, username, password, email, user_type)
VALUES (1, NOW(), NOW(), 'root', '$2b$12$mlcAuUeU5reidsdPcZm/kOR4EWkZE2lbMvyVSHLpDuzDtm6MGn0Ne', 'root@localhost', 'admin');
EOF
