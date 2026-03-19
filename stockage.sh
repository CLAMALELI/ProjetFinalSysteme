#!/bin/bash

# chemins
PROJET="/home/matteojaubert/ProjetFinalSysteme"
RRD="/home/matteojaubert/ProjetFinalSysteme/system.rrd"

# --- MACHINE 1 (VM)
CPU=$(bash $PROJET/sonde_cpu.sh)
RAM=$(python3 $PROJET/sonde_RAM.py)
MEMORY=$(bash $PROJET/sonde_memory.sh)
ORIGINE=0  # 0 pour VM

rrdtool update $RRD N:$CPU:$RAM:$MEMORY:$ORIGINE
