#!/bin/bash
# Use the find command to find image files by name
# -type f checks files only (ignores directories and links)
# -iname makes case insensitive checks
# -exec to "ls -l" the file: showing file size, file date and path
find /media/jeff -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.tif' -o -iname '*.tiff' -o -iname '*.gif' -o -iname '*.bmp' -o -iname '*.svg' -o -iname '*.webp' -o -iname '*.heif' -o -iname '*.heic' \) -exec ls -l {} \; > ~/HD_image_files.txt
