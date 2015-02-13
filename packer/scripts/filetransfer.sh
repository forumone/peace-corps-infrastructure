#/bin/bash -x

# Create a incoming folder
sudo mkdir -p /home/filetransfer

# Give it to root
sudo chown -R root:root /home/filetransfer

# Create a File Transfer User
sudo useradd --shell /bin/false --create-home --base-dir /home/filetransfer/incoming filetransfer

# Place the SSHD Config
sudo cp /tmp/files/filetransfer/sshd_config /etc/ssh/sshd_config

# Place required authorized keys
sudo su filetransfer <<'EOF'
for key in /tmp/files/filetransfer/keys/*
do
  echo "Processing $key"
  key_content=`cat $key`
  echo $key_content >> /home/filetransfer/incoming/.ssh/authorized_keys
done
EOF

# Restart SSH
sudo service ssh restart

# Set up the file deletion cronjob
echo -e "27 * * * * filetransfer bash find /home/filetransfer/incoming/*.csv -mtime +7 | xargs rm" | sudo tee /etc/cron.d/delete_old_file_transfers

