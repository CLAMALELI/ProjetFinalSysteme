#!/bin/bash

rrdtool create /home/matteojaubert/ProjetFinalSysteme/system.rrd \
--step 60 \
DS:cpu:GAUGE:120:0:100 \
DS:ram:GAUGE:120:0:100 \
DS:memory:GAUGE:120:0:100 \
RRA:AVERAGE:0.1:1:1440 #sauvegarde 24h de la base
