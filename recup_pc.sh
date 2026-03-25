#!/bin/bash

# Adresse de ton PC
PC="uapv2401103@pedago.univ-avignon.fr"
RRD="/home/matteojaubert/ProjetFinalSysteme/system.rrd"

CPU=$(ssh -i ~/.ssh/id_rsa $PC "bash ~/ProjetFinalSysteme/sonde_cpu.sh")
RAM=$(ssh -i ~/.ssh/id_rsa $PC "bash ~/ProjetFinalSysteme/sonde_RAM.sh")
MEMORY=$(ssh -i ~/.ssh/id_rsa $PC "bash ~/ProjetFinalSysteme/sonde_memory.sh")
ORIGINE=1  # 1 pour PC

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
