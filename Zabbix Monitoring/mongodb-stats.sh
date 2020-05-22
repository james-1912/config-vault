#!/bin/bash


get_MongoDB_metrics(){
python /usr/local/bin/zabbix-mongodb.py
}

# Send the results to zabbix server by using zabbix sender
result=$(get_MongoDB_metrics | /usr/bin/zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -i - 2>&1)
response=$(echo "$result" | awk -F ';' '$1 ~ /^info/ && match($1,/[0-9].*$/) {sum+=substr($1,RSTART,RLENGTH)} END {print sum}')
if [ -n "$response" ]; then
        echo "$response"
else
        echo "$result"
fi