import pandas as pd
import glob

# Get all .txt files in current directory matching the pattern
files = glob.glob("Lab7_*.txt")

for file in files:
    print(f"\nProcessing {file}...")
    
    # Read the file and display first few lines for debugging
    with open(file, 'r') as f:
        lines = f.readlines()
        print("First few lines of file:")
        for i, line in enumerate(lines[:10]):
            print(f"Line {i}: {line.strip()}")
    
    try:
        # Find where the actual data starts (after headers)
        data_start = 0
        for i, line in enumerate(lines):
            if 't' in line and 's' in line:  # Looking for the units row
                data_start = i + 1
                column_names = ['Time', 'Position', 'Velocity1', 'Acceleration1', 'Angle2', 'Velocity2', 'Acceleration2']
                print(f"Found data start at line {data_start}")
                break
        
        # Read just the numeric data lines
        data_lines = []
        for line in lines[data_start:]:
            # Skip empty lines and lines that don't start with a number
            if line.strip() and line.strip()[0].isdigit():
                # Split line on whitespace and take first 7 values
                values = line.strip().split()[:7]
                data_lines.append(','.join(values))
        
        # Create clean CSV content
        csv_content = ','.join(column_names) + '\n' + '\n'.join(data_lines)
        
        # Write clean data to new file
        new_filename = 'clean_' + file
        with open(new_filename, 'w') as f:
            f.write(csv_content)
        
        print(f"Successfully created {new_filename}")
        
        # Verify the output
        df = pd.read_csv(new_filename)
        print(f"Output file has {len(df)} rows and {len(df.columns)} columns")
        
    except Exception as e:
        print(f"Error processing {file}: {str(e)}")


