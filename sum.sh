echo "--------------------------"
echo "合計（月・カテゴリ毎）"
echo "--------------------------"

awk -F, '
NR > 1 {
    split($1, d, "-")
    month = d[1] "-" d[2]
    category = $3
    sum[month, category] += $2
}
END {
    PROCINFO["sorted_in"] = "@ind_str_asc"
    for (key in sum) {
        split(key, parts, SUBSEP)
        printf "%s\t%s\t%d\n", parts[1], parts[2], sum[key] > "output/expense_by_month_category.csv"
    }
    for (key in sum) {
        split(key, parts, SUBSEP)
        printf "%s\t%s\t%d\n", parts[1], parts[2], sum[key]
    }
}
' input/expense.csv
echo "--------------"
echo "合計（月毎）"
echo "--------------"
awk -F, '
NR > 1 {
    split($1, d, "-")
    month = d[1] "-" d[2]
    sum[month] += $2
}
END {
    for (m in sum) {
        print m, sum[m]
    }
    for (m in sum) {
        print m, sum[m] > "output/expense_by_month.csv"
    }
}
' input/expense.csv | sort 
