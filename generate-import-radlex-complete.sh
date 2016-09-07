#!/bin/bash

[ -f import-radlex-complete.sql ] && rm import-radlex-complete.sql

radlex_filename="complete-playbook-2_1.csv" 

# Extract columns (neglect header)
awk -vFPAT='([^,]+|"[^"]+")' \
    '{if (NR!=1) {print $1 "," $3 "," $4 }}' \
   $radlex_filename > radlex-complete-columns.csv

# Sanitize csv
# remove all double quotes as some fields have them, some are missing them
cat radlex-complete-columns.csv | tr -d '"' > radlex-complete-columns-sanitized.csv

# Generate final SQL insert
awk -vFPAT='([^,]+)' \
    '{print "\42" $1 "\42,\42" $2 "\42,\42" $3 "\42);" }' \
   radlex-complete-columns-sanitized.csv > radlex-complete-columns-final.csv


# Finalize SQL insert statements and output to file
while read; do
    echo "INSERT concept_reference_term
    (concept_source_id,version,creator,date_created,uuid,code,name,description)
    VALUES (1,\"2.1\",1,\"2016-08-01 12:00:00\",\"$(uuidgen)\",${REPLY}" >> import-radlex-complete.sql
done < radlex-complete-columns-final.csv
