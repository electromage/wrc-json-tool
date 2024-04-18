# wrc-json-tool
Tool for extracting various information from WebRadioControl

wrc-user-data-export-* contains several different JSON arrays, containing the station configuration, and usage information.

Arrays present in the file:
    "radioStateList"
    "radioConfigurationItemList"
    "rotatorStateList"
    "morseCodeMacroList"
    "deviceSessionList"
    "attributeList"
    "configurationAttributeList"
    "userList"
    "userSessionList"
    "deviceReservationList"

## Scripts

### Usage Guide for getUsers.sh

This script extracts user data from a specified JSON file and formats it either as a tabular output in the terminal or as a CSV file. It's designed to work with JSON files that contain a userList array.

**Prerequisites**

Ensure you have jq installed on your system, as this script relies on it to parse JSON files. You can install jq via package managers like apt for Ubuntu or brew for macOS.
Script Options

* Terminal Table Output: By default, the script outputs a formatted table to the terminal.
* CSV File Output: Optionally, the script can output the data to a CSV file.

**Script Arguments**

* <path-to-json-file>: The path to the JSON file that contains the user data.
* -c or --csv <output-file.csv>: Optional flag to specify CSV output; include the path where the CSV file should be saved.

**Usage Examples**

1. Output to Terminal:
Display the user data as a table directly in the terminal.
```
./getUsers.sh /path/to/your/jsonfile.json
```

2. Output to CSV File:
Generate a CSV file from the user data.
```
./getUsers.sh /path/to/your/jsonfile.json -c /path/to/your/outputfile.csv
```

**Output Formats**

* Terminal Table: Displays columns for UserID, FirstName, LastName, Enabled, UserName, CallSign, and EmailAddress.
* CSV File: The CSV file will have headers followed by rows containing the user data. The headers are: UserID, FirstName, LastName, Enabled, UserName, CallSign, and EmailAddress.

## Notes

Command used to extract reservations by callsign for station usage. This uses the data in the userList array to match userId to callSign, for some reason these are not stored in the same array.
    
    jq '(
     reduce .userList[] as $user ({}; .[$user.id | tostring] = $user.callSign)
     ) as $lookup
     | [ .deviceReservationList[] | .callSign = ($lookup[.userId | tostring]) ]
     | group_by(.callSign)
     | map({callsign: .[0].callSign, count: length})
     | sort_by(.count) | reverse' \
     wrc-user-data-export*.json

Print the reservation counts in a table once they have been extracted to a new JSON file.

    `jq 'to_entries | map(select(.value | type == "array")) | .[].key'`