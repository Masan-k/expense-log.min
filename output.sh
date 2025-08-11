awk -F, 'BEGIN{OFS="\t"} {print $1, $2, $3, $4, $5}' input/expense.csv > output/expense.csv
