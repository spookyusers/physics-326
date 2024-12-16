import os

def clean_csv_file(input_file, output_file):
    with open(input_file, 'r') as f:
        # Skip first 18 lines
        lines = f.readlines()[18:]
        
    # Write cleaned data to new file
    with open(output_file, 'w') as f:
        # Write header
        f.write('Time,Voltage\n')
        
        # Write data lines
        for line in lines:
            # Split by comma and take the 4th and 5th columns (time and voltage)
            parts = line.strip().split(',')
            if len(parts) >= 5:  # Ensure line has enough columns
                time = parts[3].strip()
                voltage = parts[4].strip()
                f.write(f'{time},{voltage}\n')

def process_folders(base_dir):
    # Create clean_data directory at the same level as oscill_data
    output_base = os.path.join(os.path.dirname(base_dir), 'clean_data')
    if not os.path.exists(output_base):
        os.makedirs(output_base)
    
    # Process each ALLxxxx folder
    for folder in os.listdir(base_dir):
        if folder.startswith('ALL'):
            folder_path = os.path.join(base_dir, folder)
            if os.path.isdir(folder_path):
                # Create corresponding output folder
                output_folder = os.path.join(output_base, folder)
                if not os.path.exists(output_folder):
                    os.makedirs(output_folder)
                
                # Process each CSV file in the folder
                for file in os.listdir(folder_path):
                    if file.upper().endswith('.CSV'):
                        input_path = os.path.join(folder_path, file)
                        output_path = os.path.join(output_folder, 'clean_' + file.lower())
                        clean_csv_file(input_path, output_path)
                        print(f'Processed {folder}/{file} -> {output_path}')

# Example usage - assuming you're in the directory containing the script
oscill_data_path = './oscill_data'  # Adjust this path to match your directory structure
process_folders(oscill_data_path)
