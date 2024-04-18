# Reduce userList into a lookup table of userId to callSign
reduce .userList[] as $user ({}; .[$user.id | tostring] = $user.callSign) as $lookup

# Apply the lookup table to replace userId with callSign in deviceReservationList
| [ .deviceReservationList[] | .callSign = ($lookup[.userId | tostring]) ]

# Group the results by callSign and count the occurrences
| group_by(.callSign)
| map({
    callsign: .[0].callSign,
    count: length
  })

# Sort the results by count in descending order
| sort_by(.count) | reverse
