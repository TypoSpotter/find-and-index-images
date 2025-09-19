#!/bin/bash
# Use the find command to find image files by name
# -type f checks files only (ignores directories and links)
# -iname makes case insensitive checks
# Use -o (or) to list all possible image types
# Easier to write a separate (perl) script to process file data: we will just list the files
find /media/jeff/New\ Volume/ -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.tif' -o -iname '*.tiff' -o -iname '*.gif' -o -iname '*.bmp' -o -iname '*.svg' -o -iname '*.webp' -o -iname '*.heif' -o -iname '*.heic' \) > ~/HD_image_files.txt
# The find command will list the full path
# All files found will be piped to a text file that can be processed by a different script

