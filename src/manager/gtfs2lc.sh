#!/bin/bash
#Script to organize and transform a GTFS feed into linked connections
COMPANY_NAME="$1"
LAST_MODIFIED="$2"
STORAGE="$3"

gtfs2lc-sort ${STORAGE}/datasets/${COMPANY_NAME}/${LAST_MODIFIED}_tmp
echo "Starting convertion of GTFS feed to Linked Connections..."
gtfs2lc ${STORAGE}/datasets/${COMPANY_NAME}/${LAST_MODIFIED}_tmp -f jsonld -b ${STORAGE}/datasets/${COMPANY_NAME}/baseUris.json -S LevelStore > ${STORAGE}/linked_connections/${COMPANY_NAME}/${LAST_MODIFIED}_tmp.jsonld
rm -r ${STORAGE}/datasets/${COMPANY_NAME}/${LAST_MODIFIED}_tmp
rm ${STORAGE}/datasets/${COMPANY_NAME}/baseUris.json
echo "Sorting Linked Connections by Departure Time..."
sort -T ${STORAGE}/tmp/ -t \" -k 17 ${STORAGE}/linked_connections/${COMPANY_NAME}/${LAST_MODIFIED}_tmp.jsonld > ${STORAGE}/linked_connections/${COMPANY_NAME}/${LAST_MODIFIED}.jsonld
rm ${STORAGE}/linked_connections/${COMPANY_NAME}/${LAST_MODIFIED}_tmp.jsonld
echo "Compressing Linked Connections..."
gzip ${STORAGE}/linked_connections/${COMPANY_NAME}/${LAST_MODIFIED}.jsonld
mkdir ${STORAGE}/linked_pages/${COMPANY_NAME}/${LAST_MODIFIED}