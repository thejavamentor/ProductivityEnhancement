#!/bin/bash

startdate="2024-06-09"
enddate="2024-07-23"

# Convert dates to timestamps
sDateTs=$(date -d "$startdate" "+%s")
eDateTs=$(date -d "$enddate" "+%s")
dateTs=$sDateTs
offset=86400  # One day in seconds

# Debug prints
echo "Start date: $startdate ($sDateTs)"
echo "End date: $enddate ($eDateTs)"

while [ "$dateTs" -le "$eDateTs" ]
do
  date_param=$(date -d "@$dateTs" "+%Y-%m-%d")
  echo "Processing date: $date_param ($dateTs)"

  # Execute the script with the current date parameter
  sh run.sh /warehouse/data/prod_soh.db/soh-comparison apps $date_param GAP_RESET_DATA_TRIGGER PROD_SOH_COMPARE soh_comparison_prod-0.1-py3-none-any.whl prod svc-sohprdusr
  #sh test.sh $date
  dateTs=$(($dateTs+$offset))

  # Check if the script executed successfully
  if [ $? -ne 0 ]; then
    echo "Error processing date: $date_param"
    exit 1
  fi

  # Increment the date by one day
  dateTs=$((dateTs + offset))
  
  # Print the new timestamp for debugging
  echo "Next timestamp: $dateTs"

  # Optional: sleep for a while between executions
  sleep 2
done

echo "Processing complete."


## To execut in loop run below command as a background process.
# sh iterate_and_run.hs &
