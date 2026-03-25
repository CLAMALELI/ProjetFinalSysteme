#!/bin/bash

# chemins
PROJET="/home/matteojaubert/ProjetFinalSysteme"
RRD="/home/matteojaubert/ProjetFinalSysteme/system.rrd"
GRAPH_PATH="$PROJET/graph0.png"

CPU=$(bash $PROJET/sonde_cpu.sh)
RAM=$(python3 $PROJET/sonde_RAM.py)
MEMORY=$(bash $PROJET/sonde_memory.sh)
ORIGINE=0  # 0 pour VM

rrdtool update $RRD N:$CPU:$RAM:$MEMORY:$ORIGINE

rrdtool graph $GRAPH_PATH \
  --start -1h \
  --title "Utilisation des ressources (1h)" \
  --vertical-label "%" \
  --lower-limit 0 \
  --upper-limit 100 \
  DEF:cpu=$RRD:cpu:AVERAGE \
  DEF:ram=$RRD:ram:AVERAGE \
  DEF:disk=$RRD:memory:AVERAGE \
  DEF:origine=$RRD:origine:AVERAGE \
  LINE1:cpu#FF0000:"CPU" \
  LINE1:ram#00FF00:"RAM" \
  LINE1:disk#0000FF:"DISK" \
  LINE1:origine#FFFF00:"ORIGINE"
  
scp graph0.png uapv2401103@pedago.univ-avignon.fr:/home/nas-wks01/users/uapv2401103/Donnees_itinerantes/public_html/monitoring/


