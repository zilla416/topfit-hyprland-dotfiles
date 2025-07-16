#!/bin/bash

# CPU usage
cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')

# Memory usage
mem=$(free | awk '/Mem:/ {printf("%.1f%%", $3/$2 * 100)}')

echo "CPU: $cpu | Mem: $mem | TopFit"
