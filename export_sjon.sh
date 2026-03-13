#!/bin/bash

rrd="/home/matteojaubert/ProjetFinalSysteme/system.rrd"
export_file="/home/matteojaubert/ProjetFinalSysteme/file.json"

/usr/bin/rrdtool xport --json --start -60m --step 60 \
    DEF:c=$rrd:cpu:AVERAGE \
    DEF:r=$rrd:ram:AVERAGE \
    DEF:d=$rrd:disque:AVERAGE \
    XPORT:c:"CPU" XPORT:r:"RAM" XPORT:d:"DISQUE" > $export_file
