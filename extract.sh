#!/bin/bash

musicFolder='/mnt/c/Users/woza/Music'
outputFolderName='mp3'
sourceFile=$1

echo "Extracting album file: $sourceFile"

extractFolder="$musicFolder/_tmp/"
# unar -o extractFolder "$sourceFile"
ls -lR "$extractFolder"
read -n 1 -p "If files order is correct, press any key to continue..."

# /source/mp3merge/mp3merge.ps1 -Recursive $extractFolder

file=$(basename -s .zip -- "$sourceFile")
# echo "$file"

find $extractFolder -name "$file.mp3" | mv /mnt/c/Users/woza/Music/_tmp/Solipsism & Nacht Plank - The Cerenarian Sea/


# mv /mnt/c/Users/woza/Music/_new12/ /mnt/c/Users/woza/Music/mp3/
# ls -l /mnt/c/Users/woza/Music/_new12/
# rm -r /mnt/c/Users/woza/Music/_new12/