##################################################
# Delete Cronjob
##################################################

Unregister-ScheduledJob -Name "Speedtest" -Confirm:$false

exit 0
