import os
import shutil
from pathlib import Path

def copy_folder_structure(src_folder, dest_folder):
    for folder, _, files in os.walk(src_folder):
        dest_folder_current = folder.replace(src_folder, dest_folder, 1)
        Path(dest_folder_current).mkdir(parents=True, exist_ok=True)

        for file in files:
            src_file = os.path.join(folder, file)
            dest_file = os.path.join(dest_folder_current, file)

            if os.path.exists(dest_file):
                src_file_mtime = os.path.getmtime(src_file)
                dest_file_mtime = os.path.getmtime(dest_file)

                if src_file_mtime > dest_file_mtime:
                    shutil.move(src_file, dest_file)
                    print(f"Moved file: {src_file} -> {dest_file}")
            else:
                shutil.move(src_file, dest_file)
                print(f"Moved file: {src_file} -> {dest_file}")

source_folder = "D:\\BOOKS"
destination_folder = "D:\\LATEST ORGANIZED BACKUP"

copy_folder_structure(source_folder, destination_folder)
print("Operation completed.")
