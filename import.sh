#!/bin/bash

sudo docker volume create osm-data

sudo docker volume create osm-tiles

cd osm-bright 
wget https://ftp.fau.de/pub/openstreetmapdata.com-archive/2022-01-30/simplified-land-polygons-complete-3857.zip
sudo apt-get install unzip
unzip simplified-land-polygons-complete-3857.zip
cd simplified-land-polygons-complete-3857 
grep -L -r 'simplified' | xargs -I '{}' mv {} ..
cd ..

wget https://ftp.fau.de/pub/openstreetmapdata.com-archive/2022-01-30/land-polygons-split-3857.zip
unzip land-polygons-split-3857.zip
cd land-polygons-split-3857
grep -L -r 'land-polygons' | xargs -I '{}' mv {} ..
cd ..

wget http://mapbox-geodata.s3.amazonaws.com/natural-earth-1.4.0/cultural/10m-populated-places-simple.zip
unzip 10m-populated-places-simple.zip
cd ..

sudo docker build . -t tile_image


sudo docker run \
 -e DOWNLOAD_PBF=https://download.geofabrik.de/russia/northwestern-fed-district-latest.osm.pbf  \
 -e DOWNLOAD_POLY=https://download.geofabrik.de/russia/northwestern-fed-district.poly \
 -e NAME_MML=osm-bright.osm2pgsql.mml  \
 -v ./osm-bright:/data/style/ \
 -v osm-data:/data/database/ \ 
 -d tile_image \
import
