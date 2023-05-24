##################################################
# Delete Cronjob
##################################################

Unregister-ScheduledTask -TaskName "Speedtest" -Confirm:$false

exit 0
