import os
import csv
import re

# get current working directory
cwd = os.getcwd()

# define function to format phone numbers
def format_phone_number(number):
    number = str(number) # convert to string
    pattern = r'(\d{3})(\d{3})(\d{4})' # regex pattern for 10-digit phone number
    if re.match(pattern, number): # check if number matches pattern
        formatted_number = re.sub(pattern, r'(\1) \2-\3', number) # format number
        return formatted_number
    else:
        return number # return original number if it doesn't match pattern

# list of column names to look for
column_names = ['Landline', 'Landline 2', 'Landline 3', 'Cell', 'Cell 2', 'Cell 3', 'Cell 4', 'Phone', 'Phone 2']

# loop through all files in current directory
for filename in os.listdir(cwd):
    filepath = os.path.join(cwd, filename)
    if os.path.isfile(filepath):
        # check if file is an Excel or CSV file
        if filepath.endswith('.xlsx') or filepath.endswith('.xls'):
            # print error message since openpyxl is not installed
            print(f"Error: {filename} is an Excel file but openpyxl is not installed. Please install openpyxl to process Excel files.")
        elif filepath.endswith('.csv'):
            # read CSV file into list of rows
            with open(filepath, newline='', encoding='utf-8') as f:
                reader = csv.reader(f)
                rows = list(reader)
            
            # remove columns that start with "DNC"
            header_row = 0
            cols_to_remove = [i for i in range(len(rows[header_row])) if rows[header_row][i].startswith('DNC')]
            for row in range(len(rows)):
                for col in reversed(cols_to_remove):
                    del rows[row][col]
            
            # get header row and column indices for all column names
            header_row = 0
            header_cols = [i for i in range(len(rows[header_row])) for name in column_names if rows[header_row][i] == name]
            
            # loop through data rows and format phone numbers in all specified columns
            for row in range(header_row+1, len(rows)):
                for col in header_cols:
                    num = rows[row][col]
                    formatted_num = format_phone_number(num)
                    rows[row][col] = formatted_num
            
            # write formatted data to new CSV file
            output_filename = '[FORMATTED]' + filename
            output_filepath = os.path.join(cwd, output_filename)
            with open(output_filepath, 'w', newline='', encoding='utf-8') as f:
                writer = csv.writer(f)
                writer.writerows(rows)
            
            # print message to indicate completion
            print(f"Formatted file saved as {output_filename} in {cwd}")