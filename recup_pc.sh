#!/bin/bash

# Adresse de ton PC
PC="uapv2401103@pedago.univ-avignon.fr"

CPU=$(ssh -i ~/.ssh/id_rsa $PC "bash ~/ProjetFinalSysteme/sonde_CPU.sh")
RAM=$(ssh -i ~/.ssh/id_rsa $PC "python3 ~/ProjetFinalSysteme/sonde_RAM.py")
DISK=$(ssh -i ~/.ssh/id_rsa $PC "bash ~/ProjetFinalSysteme/sonde_memory.sh")

rrdtool update $RRD N:$CPU:$RAM:$MEMORY
