#!/bin/bash

source bench/config.sh

# copy from bench/do.sh
workloads=(a b c d)
threads=(40 80 120 160 200 240 280 320 360 400 440 480)

function parse_ycsb_score() {
    local log="${1}"
    cat "${log}" |
        grep "OPS:" |
        awk -F 'OPS: ' '{print $2}' |
        awk -F ',' '{print $1}' |
        awk '{sum += $1} END {print sum}'
}

# Output format
# Type  ops min avg p99 p999    p9999   max
function parse_ycsb_summary() {
    local log="${1}"
    local thread=$2
    cat "${log}" | awk -F '- ' -v thread="${thread}" '
	BEGIN {
		map["Takes(s)"] = "takes"
		map["Count"] = "count"
		map["OPS"] = "ops"
		map["Avg(us)"] = "avg"
		map["Min(us)"] = "min"
		map["Max(us)"] = "max"
		map["99th(us)"] = "p99"
		map["99.9th(us)"] = "p999"
		map["99.99th(us)"] = "p9999"
	}
	/READ/ || /UPDATE/ || /INSERT/ || /SCAN/ || /READ_MODIFY_WRITE/ || /DELETE/ {
		split($2,items,", ")
		gsub(/ /, "", $1)
		if ($1 in result); else {
			result[$1]["size"] = 0
			result[$1]["min"] = 1000000000
			result[$1]["max"] = 0
		}
		result[$1]["size"] += 1
		for (idx in items) {
			split(items[idx],pairs,": ")
			name=map[pairs[1]]
			switch (name) {
			case "takes":
			case "count":
			case "ops":
			case "avg":
			case "p99":
			case "p999":
			case "p9999":
				if (name in result[$1]); else
					result[$1][name] = 0
				result[$1][name] += pairs[2]
				break
			case "min":
				if (result[$1][name] > pairs[2])
					result[$1][name] = pairs[2]
				break
			case "max":
				if (result[$1][name] < pairs[2])
					result[$1][name] = pairs[2]
				break
			}
		}
	}
	END {
		for (type in result) {
			columns[0]="ops"
            columns[1]="min"
            columns[2]="avg"
            columns[3]="p99"
            columns[4]="p999"
            columns[5]="p9999"
            columns[6]="max"
			size=result[type]["size"]
			if (size == 0) continue;

            printf type " " thread " "
            for (col in columns) {
                col = columns[col]
				val = result[type][col]
				switch (col) {
				case "avg":
				case "ops":
				case "p99":
				case "p999":
				case "p9999":
					val = val / size
				}
                printf val " "
            }
            printf "\n"
		}
	}
'
}

for suffix in ${workloads[@]}; do
    summary=${TEST_NAME}/${TEST_NAME}.workload${suffix}.summary.log
    echo "type thread ops min avg p99 p999 p9999 max" | tee $summary
    for thread in ${threads[@]}; do
        file=${TEST_NAME}/${TEST_NAME}.${thread}.workload${suffix}.log
        parse_ycsb_summary $file $thread | tee -a $summary
    done
done
