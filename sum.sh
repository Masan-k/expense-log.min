awk -F, 'NR>1 {sum += $2} END {print sum}' expence.txt
