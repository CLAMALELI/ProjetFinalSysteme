#!/bin/bash

# Adresse de ton PC
PC="uapv2401103@pedago.univ-avignon.fr"

# Récupération CPU
CPU=$(ssh -i ~/.ssh/id_rsa $PC "bash ~/ProjetFinalSysteme/sonde_CPU.sh")
echo "CPU PC: $CPU"

# Récupération RAM
RAM=$(ssh -i ~/.ssh/id_rsa $PC "python3 ~/ProjetFinalSysteme/sonde_RAM.py")
echo "RAM PC: $RAM"

# Récupération disque
DISK=$(ssh -i ~/.ssh/id_rsa $PC "bash ~/ProjetFinalSysteme/sonde_memory.sh")
echo "DISK PC: $DISK"

# Mettre à jour RRD ou générer graphique ici si besoin
# rrdtool update system.rrd N:$CPU:$RAM:$DISK
