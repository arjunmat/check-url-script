#!/bin/bash

ERRORS=0
PATH_COUNT=0

# Check if the file is provided as an argument
if [ $# -eq 0 ]
  then
    echo "Usage: [Linux/Mac] ./url-check <file_with_paths_to_check>"
    echo "Usage: [Windows PowerShell] .\url-check <file_with_paths_to_check>"
    exit 1
fi

while IFS= read -r path; do
  echo "Checking $path... "

  PATH_COUNT=$((PATH_COUNT+1))

  STATUS_CODE=$(curl \
      --output /dev/null \
      --silent \
      --write-out "%{http_code}" \
      "$path")

  if (( STATUS_CODE == 200 ))
  then
    echo "$STATUS_CODE OK"
  else
    echo -e "$STATUS_CODE Failed."
    ERRORS=$(( ERRORS + 1 ))
  fi
done < "$1"

if (( ERRORS > 0 ))
then
  echo -e "Tested $PATH_COUNT urls. $ERRORS failed"
  exit 1
fi