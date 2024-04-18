#!/bin/bash

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <path-to-json-file> [-c|--csv <output-file.csv>]"
    exit 1
fi

# Parse arguments
JSON_FILE="$1"
OUTPUT_MODE="table"  # Default output mode
OUTPUT_FILE=""

shift  # Move past the first argument
while (( "$#" )); do
    case "$1" in
        -c|--csv)
            OUTPUT_MODE="csv"
            OUTPUT_FILE="$2"
            shift 2
            ;;
        *)  # Preserve unexpected arguments
            shift
            ;;
    esac
done

# Validate the JSON file existence
if [ ! -f "$JSON_FILE" ]; then
    echo "Error: File does not exist."
    exit 1
fi

# Function to output CSV
output_csv() {
    # Define headers as a CSV string
    HEADERS="UserID,FirstName,LastName,Enabled,UserName,CallSign,EmailAddress"
    
    # Write headers to the output file
    echo "$HEADERS" > "$OUTPUT_FILE"
    
    # Append the data to the file
    jq -r '.userList[] | [ .id, .firstName, .lastName, .enabled, .username, .callSign, .email ] | @csv' "$JSON_FILE" >> "$OUTPUT_FILE"
}

# Function to output Table
output_table() {
    (
    echo -e "UserID\tFirstName\tLastName\tEnabled\tUserName\tCallSign\tEmailAddress"
    jq -r '.userList[] | [ .id, .firstName, .lastName, .enabled, .username, .callSign, .email ] | @tsv' "$JSON_FILE"
    ) | column -t -s $'\t'
}

# Decide output format based on user input
if [ "$OUTPUT_MODE" == "csv" ]; then
    output_csv
else
    output_table
fi
