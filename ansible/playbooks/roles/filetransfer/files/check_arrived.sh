#!/bin/bash

source /home/filetransfer/no_file_emails.sh

if [[ -z $(find /home/filetransfer/incoming/*.csv -mtime 0) ]]; then
  message="Subject: No file in 24 hours\n\n"
  message="$message The latest files (files deleted every 7 days):\n"
  message="$message `ls /home/filetransfer/incoming/*.csv`"
  echo -e $message | sendmail -f "Donate Server <noreply@donate.peacecorps.gov>" $NO_FILE_EMAILS
fi
