#!/bin/bash

# Adresse de ton PC
PC="uapv2401103@pedago.univ-avignon.fr"
RRD="/home/matteojaubert/ProjetFinalSysteme/system.rrd"

CPU=$(ssh -i ~/.ssh/id_rsa $PC "bash ~/ProjetFinalSysteme/sonde_cpu.sh")
RAM=$(ssh -i ~/.ssh/id_rsa $PC "python3 ~/ProjetFinalSysteme/sonde_RAM.py")
MEMORY=$(ssh -i ~/.ssh/id_rsa $PC "bash ~/ProjetFinalSysteme/sonde_memory.sh")

echo $CPU
echo $RAM
echo $MEMORY
rrdtool update $RRD N:$CPU:$RAM:$MEMORY
