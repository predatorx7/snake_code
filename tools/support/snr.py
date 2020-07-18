"""Helper python script to do "inline search & replace" for update_version.sh"""

from tempfile import mkstemp
from shutil import move, copymode
from os import fdopen, remove
from sys import argv

def replace(pattern, subst, file_path):
    #Create temp file
    fh, abs_path = mkstemp()
    with fdopen(fh,'w') as new_file:
        with open(file_path) as old_file:
            for line in old_file:
                new_file.write(line.replace(pattern, subst))
    #Copy the file permissions from the old file to the new file
    copymode(file_path, abs_path)
    #Remove original file
    remove(file_path)
    #Move new file
    move(abs_path, file_path)

replace(argv[1], argv[2], argv[3])