#! /bin/bash

source=/path/to/source
dest=/path/to/dest
# Please ensure you have read access to the source folder and write access to the destination folder

max_backups=30
backup_name=backup

echo "[INFO] Starting backup script."

backup_folder="$dest/$(date -I)"

if [ -e $backup_folder ]
then
    echo "[INFO] Backup script already executed today, exiting."
    exit
else
    echo "[INFO] Creating backup folder at $backup_folder."
    mkdir $backup_folder
fi

until [ $(ls $dest | wc -l) -lt $(($max_backups + 1)) ]
do
    echo "[INFO] Max backups amount has been matched."
    folder_to_delete="$dest/$(ls -1 -tr $dest | head -1)"
    echo "[INFO] Deleting backup at date $folder_to_delete."
    rm -rf $folder_to_delete
done

echo "[INFO] Creating tar archive"

location=$(pwd)
cd $source
# Avoids having the complete file structure when decompressing

archive_path="$backup_folder/$backup_name.tar.gz"
if tar -czf $archive_path .
then
    echo "[INFO] Tar archive successfully created."
else
    echo "[WARN] An error occured exiting."
    exit
fi

cd $location

echo "[INFO] Creating SHA256SUM."
sha256sum $archive_path > $backup_folder/SHA256.txt

echo "[INFO] SHA256SUM created."
echo "[INFO] Backup successful."
