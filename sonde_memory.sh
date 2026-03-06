#!/bin/bash

while true; do
  free | awk '/Mem:/ {printf("Utilisation Memoire: %.2f%%\n", $3/$2 * 100)}'
  sleep 2m
done
