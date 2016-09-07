#!/bin/bash

[ -f import-radlex-complete.sql ] && rm import-radlex-complete.sql

# Sanitize csv
# remove header
# remove all double quotes as some fields have them, some are missing them
tail -n +2 complete-playbook-2_1.csv | tr -d '"' > complete-playbook-2_1-sanitized.csv

# Extract columns and generate end of SQL insert satements
awk -vFPAT='([^,]+|"[^"]+")' \
   '{print "\42" $1 "\42,\42" $3 "\42,\42" $4 "\42);" }' \
   complete-playbook-2_1-sanitized.csv > radlex-complete-columns.csv

# Finalize SQL insert statements and output to file
while read; do
    echo "INSERT concept_reference_term
    (concept_source_id,version,creator,date_created,uuid,code,name,description)
    VALUES (1,\"2.1\",1,\"2016-08-01 12:00:00\",\"$(uuidgen)\",${REPLY}" >> import-radlex-complete.sql
done < radlex-complete-columns.csv
