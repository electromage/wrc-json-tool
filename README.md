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

For more detail see [keys.json](keys.json)

## Scripts

### Usage Guide for getUsers.sh

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
