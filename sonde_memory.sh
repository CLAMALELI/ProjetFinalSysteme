#!/bin/bash

total=$(free | awk '/Mem:/ {print int($3/$2 * 100)}'')
echo "$total"
