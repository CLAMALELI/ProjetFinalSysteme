#!/bin/bash

# chemins
PROJET="/home/matteojaubert/ProjetFinalSysteme"
RRD="$PROJET/system.rrd"

CPU=$(bash $PROJET/sonde_CPU.sh)
RAM=$(python3 $PROJET/sonde_RAM.py)
MEMORY=$(bash $PROJET/sonde_memory.sh)

rrdtool update $RRD N:$CPU:$RAM:$MEMORY
