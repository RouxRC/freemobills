#!/bin/bash

mkdir -p data

echo "mois,sms" > data/stats_sms.csv
ls factures/*.pdf | while read f; do
  sms=$(pdftotext -raw "$f" -                |
         tr '\n' ' '                         |
         sed 's/France/france/g'             |
         sed 's/\( [A-Z][A-Za-z]\)/\n\1/g'   |
         grep "\(Envois\|MS depuis\)"        |
         sed 's/^[^0-9]\+//'                 |
         sed 's/[^0-9].*$//'                 |
         awk '{s+=$1} END {print s}')
  echo "$month,$sms"
  month=$(echo $f                            |
           sed -r 's/^.* ([0-9].*)\.pdf/\1/' |
           sed 's|_|/|')
done | grep -v "^," >> data/stats_sms.csv

