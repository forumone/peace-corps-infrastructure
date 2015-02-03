#!/bin/bash

source /home/filetransfer/no_file_emails.sh

if [[ -z $(find /home/filetransfer/incoming/*.csv -mtime 0) ]]; then
  message="To: $NO_FILE_EMAILS\nSubject: No file in 24 hours\n\n"
  message="$message The latest files (files deleted every 7 days):\n\n"
  message="$message `ls -l /home/filetransfer/incoming/*.csv | awk '{print $9" UTC:"$6" "$7" "$8"\\n"}'`"
  echo -e $message | sendmail -F "Donate Server" -f noreply@donate.peacecorps.gov -t
fi
