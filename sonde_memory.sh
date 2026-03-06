#!/bin/bash

function memory(){
  free | awk '/Mem:/ {printf("Utilisation RAM: %.2f%%\n", $3/$2 * 100)}'
}
