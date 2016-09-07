#!/bin/bash

[ -f import-radlex-complete.sql ] && rm import-radlex-complete.sql

tail -n +2 complete-playbook-2_1.csv | sed -e "s/\"/'/g" > complete-playbook-2_1-sanitized.csv

awk -F, '{if (NR!=1) {print "\47" sq $1 "\47," $3 sq "," sq $4 }}' complete-playbook-2_1-sanitized.csv > radlex-complete-columns.csv

while read; do
    echo "INSERT concept_reference_term
    (concept_source_id,version,creator,date_created,uuid,code,name,description)
    VALUES (1,'2.1',1,'2016-08-01 12:00:00','"$(uuidgen)"',"${REPLY}");" >> import-radlex-complete.sql
done < radlex-complete-columns.csv
