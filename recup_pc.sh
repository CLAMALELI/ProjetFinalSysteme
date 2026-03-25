#!/bin/bash

# Adresse de ton PC
PC="uapv2401103@pedago.univ-avignon.fr"
RRD="/home/matteojaubert/ProjetFinalSysteme/system.rrd"

CPU=$(ssh -i ~/.ssh/id_rsa $PC "bash ~/ProjetFinalSysteme/sonde_cpu.sh")
RAM=$(ssh -i ~/.ssh/id_rsa $PC "bash ~/ProjetFinalSysteme/sonde_RAM.sh")
MEMORY=$(ssh -i ~/.ssh/id_rsa $PC "bash ~/ProjetFinalSysteme/sonde_memory.sh")
ORIGINE=1  # 1 pour PC

rrdtool update $RRD N:$CPU:$RAM:$MEMORY:$ORIGINE

