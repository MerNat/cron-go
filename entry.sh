#!/bin/sh

# Here a command should be put to run the go script
echo "Running service once before starting our cron ... "
# start cron
/usr/src/app/cron-job-service
sleep 2
echo "Running cron ..."
/usr/sbin/crond -f -l 8