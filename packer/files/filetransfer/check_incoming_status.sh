#!/bin/bash

if [[ -z $(find /home/filetransfer/incoming/*.csv -mtime 0) ]]; then
  echo -e "To: {{NO_FILE_EMAILS}}\nSubject: No file in 24 hours\n" > /tmp/warn_email.txt
  echo -e "The latest files (files deleted every 7 days):\n" >> /tmp/warn_email.txt
  ls -l /home/filetransfer/incoming/*.csv | awk '{print $9" UTC:"$6" "$7" "$8}' >> /tmp/warn_email.txt
  cat /tmp/warn_email.txt | /usr/sbin/sendmail -F "Donate Server" -f noreply@peacecorps.gov -t
  rm /tmp/warn_email.txt
fi
