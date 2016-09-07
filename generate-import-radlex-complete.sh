#!/bin/bash

[ -f import-radlex-complete.sql ] && rm import-radlex-complete.sql

awk -vFPAT='([^,]+|"[^"]+")' \
   '{if (NR!=1) {print "\42" $1 "\42," $3 "," $4 ");" }}' \
   complete-playbook-2_1.csv > radlex-complete-columns.csv

while read; do
    echo "INSERT concept_reference_term
    (concept_source_id,version,creator,date_created,uuid,code,name,description)
    VALUES (1,\"2.1\",1,\"2016-08-01 12:00:00\",\"$(uuidgen)\",${REPLY}" >> import-radlex-complete.sql
done < radlex-complete-columns.csv
