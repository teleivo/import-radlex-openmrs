#!/bin/bash

[ -f import-radlex-core.sql ] && rm import-radlex-core.sql

tail -n +2 core-playbook-2_1.csv | sed -e "s/\"/'/g" > core-playbook-2_1-sanitized.csv

awk -F, '{if (NR!=1) {print "\47" sq $1 "\47," $3 sq "," sq $4 }}' core-playbook-2_1-sanitized.csv > radlex-core-columns.csv

while read; do
    echo "INSERT concept_reference_term
    (concept_source_id,version,creator,date_created,uuid,code,name,description)
    VALUES (1,'2.1',1,'2016-08-01 12:00:00','"$(uuidgen)"',"${REPLY}");" >> import-radlex-core.sql
done < radlex-core-columns.csv
