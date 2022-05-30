#!/bin/bash

sudo docker run \
    -p 80:80 \
    -e NAME_MML=osm-bright.osm2pgsql.mml \
    -e THREADS=16 \
    -e "OSM2PGSQL_EXTRA_ARGS=-C 4096" \
    -v ./osm-bright:/data/style/ \
    -v osm-data:/data/database/ \
    -d tile_image \
    run