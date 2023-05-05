import os
import shutil

def remove_read_only_flag(file_path):
    os.chmod(file_path, os.stat(file_path).st_mode | 0o666)

def create_folder_if_not_exists(root_dir, folder_name):
    folder_path = os.path.join(root_dir, folder_name)
    if not os.path.exists(folder_path):
        os.mkdir(folder_path)
    return folder_path

def move_files_with_extensions(root_dir, folder_name, file_extensions):
    folder_path = create_folder_if_not_exists(root_dir, folder_name)

    for my_folder_name, _, file_names in os.walk(root_dir):
        for file_name in file_names:
            file_extension = os.path.splitext(file_name)[-1].lower()

            if file_extension in file_extensions:
                file_path = os.path.join(my_folder_name, file_name)
                remove_read_only_flag(file_path)
                destination_path = os.path.join(folder_path, file_name)
                shutil.move(file_path, destination_path)

def delete_empty_folders(root_dir):
    folders_deleted = 0
    while True:
        for folder_name, subfolders, file_names in os.walk(root_dir, topdown=False):
            if not subfolders and not file_names:
                try:
                    os.rmdir(folder_name)
                    print(f"Deleted empty folder: {folder_name}")
                    folders_deleted += 1
                except OSError as e:
                    print(f"Error deleting folder {folder_name}: {e}")

        if folders_deleted == 0:
            break
        folders_deleted = 0

def delete_files_with_extensions(root_dir, file_extensions):
    for folder_name, _, file_names in os.walk(root_dir):
        for file_name in file_names:
            file_extension = os.path.splitext(file_name)[-1].lower()

            if file_extension in file_extensions:
                file_path = os.path.join(folder_name, file_name)
                remove_read_only_flag(file_path)
                os.remove(file_path)
                print(f"Deleted file: {file_path}")

def move_documents(root_dir):
    word_extensions = ['.doc', '.docx', '.docm', '.dot', '.dotx', '.dotm', '.odt']
    excel_extensions = ['.csv', '.xls', '.xlsx', '.xlsm', '.xlsb', '.xlt', '.xltx', '.xltm', '.xla', '.xlam']
    powerpoint_extensions = ['.ppt', '.pptx']
    onenote_extensions = ['.one']
    image_extensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.ico']
    video_extensions = ['.mp4']
    audio_extensions = ['.mp3', '.m4a', '.aac']
    compressed_extensions = ['.zip', '.rar']
    pdf_extensions = ['.pdf']
    text_extensions = ['.txt']
    ebooks_extensions = ['.epub', '.mobi', '.azw3']
    delete_extensions = ['.lnk', '.url', '.kpf']
    markdown_extensions = ['.md']

    move_files_with_extensions(root_dir, "All PDF Documents", pdf_extensions)
    move_files_with_extensions(root_dir, "All Word Documents", word_extensions)
    move_files_with_extensions(root_dir, "All Powerpoint Documents", powerpoint_extensions)
    move_files_with_extensions(root_dir, "All One Note Documents", onenote_extensions)
    move_files_with_extensions(root_dir, "All Excel Documents", excel_extensions)
    move_files_with_extensions(root_dir, "All Images", image_extensions)
    move_files_with_extensions(root_dir, "All Videos", video_extensions)
    move_files_with_extensions(root_dir, "All Audios", audio_extensions)
    move_files_with_extensions(root_dir, "All Compressed Files", compressed_extensions)
    move_files_with_extensions(root_dir, "All Text Files", text_extensions)
    move_files_with_extensions(root_dir, "All e-books", ebooks_extensions)
    move_files_with_extensions(root_dir, "All Markdown Documents", markdown_extensions)
    
    delete_files_with_extensions(root_dir, delete_extensions)
    delete_empty_folders(root_dir)
    

root_directory = "C:\\Users\\ketan\\Downloads"

move_documents(root_directory)
