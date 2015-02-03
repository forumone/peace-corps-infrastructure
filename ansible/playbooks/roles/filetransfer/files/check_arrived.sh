#!/bin/bash

source /home/filetransfer/no_file_emails.sh

if [[ -z $(find /home/filetransfer/incoming/*.csv -mtime 0) ]]; then
  message="To: $NO_FILE_EMAILS\nSubject: No file in 24 hours\n\n"
  message="$message The latest files (files deleted every 7 days):\n\n"
  for line in `ls -l /home/filetransfer/incoming/*.csv`; do
    message="$message $line\n"
  done
  echo -e $message | sendmail -F "Donate Server" -f noreply@donate.peacecorps.gov -t
fi
