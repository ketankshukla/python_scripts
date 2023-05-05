import os
import re

def is_target_file(file_name, file_extensions):
    return any(file_name.endswith(extension) for extension in file_extensions)

def remove_comments_and_blank_lines(code, file_extension):
    if file_extension == ".dart":
        # Split code into lines
        lines = code.splitlines()

        # Process lines
        processed_lines = []
        inside_multi_line_comment = False
        for line in lines:
            if not inside_multi_line_comment:
                # Remove single line comments
                line = re.sub(r'//.*$', '', line)

                # Check for start of multi-line comment
                if '/*' in line:
                    line = re.sub(r'/\*.*', '', line)
                    inside_multi_line_comment = True

            # Check for end of multi-line comment
            if inside_multi_line_comment and '*/' in line:
                line = re.sub(r'.*\*/', '', line)
                inside_multi_line_comment = False

            processed_lines.append(line)

        # Rejoin lines and remove consecutive empty lines
        code = "\n".join(processed_lines)
        code = re.sub(r'\n\s*\n\s*\n', '\n\n', code)
    return code

def process_directory(directory, file_extensions):
    for root, _, files in os.walk(directory):
        for file_name in files:
            file_extension = os.path.splitext(file_name)[-1]
            if is_target_file(file_name, file_extensions):
                file_path = os.path.join(root, file_name)
                with open(file_path, 'r', encoding='utf-8') as file:
                    content = file.read()
                content = remove_comments_and_blank_lines(content, file_extension)
                with open(file_path, 'w', encoding='utf-8') as file:
                    file.write(content.strip())

def clean_dart_files(root_directory):
    file_extensions = ['.dart']
    process_directory(root_directory, file_extensions)

# Set the root directory and the Flutter project directory
root_dir = "D:\\projects"
flutter_project_dir = os.path.join(root_dir, "flutty")

clean_dart_files(flutter_project_dir)
