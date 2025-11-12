cd "$(dirname "$0")"
awk -F, 'BEGIN{OFS="\t"} {print $1, $2, $3, $4, $5}' input/expense.csv > output/expense.csv
echo "--------------------------"
echo "合計（月・カテゴリ毎）"
echo "--------------------------"
# 事前に出力フォルダ
mkdir -p output

awk -F, '
NR > 1 {
    # $1 = 日付(YYYY-MM-DD), $2 = 金額, $3 = カテゴリ を想定
    split($1, d, "-")
    m = d[1] "-" d[2]       # 月キー (YYYY-MM)
    sum[m][$3] += $2        # 多次元配列に集計
}
END {
    # 月→カテゴリの文字列昇順で走査（gawk）
    PROCINFO["sorted_in"] = "@ind_str_asc"

    out = "output/expense_by_month_category.csv"
    print "month,category,amount" > out   # 見出し行（必要なければ削除）

    for (m in sum) {
        for (c in sum[m]) {
            # ファイルは追記（>>）にする
            printf "%s,%s,%d\n", m, c, sum[m][c] >> out
            # 標準出力にも表示したい場合
            printf "%s,%s,%d\n", m, c, sum[m][c]
        }
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
