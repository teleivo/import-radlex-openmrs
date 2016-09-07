#!/bin/bash

[ -f import-radlex-core.sql ] && rm import-radlex-core.sql

awk -vFPAT='[^,]*|"[^"]*"'']"' '{if (NR!=1) {print "\42" sq $1 "\42," $3 sq","sq $4 sq ");" }}' core-playbook-2_1.csv > radlex-core-columns.csv

while read; do
    echo "INSERT concept_reference_term
    (concept_source_id,version,creator,date_created,uuid,code,name,description)
    VALUES (1,\"2.1\",1,\"2016-08-01 12:00:00\",\"$(uuidgen)\",${REPLY}" >> import-radlex-core.sql
done < radlex-core-columns.csv
