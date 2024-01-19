#!/bin/sh -eu
createdb meta.sr.ht
psql -d meta.sr.ht </data/meta.sr.ht.sql
