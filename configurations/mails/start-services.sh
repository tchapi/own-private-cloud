#!/bin/bash

# Start rspamd
rspamd --insecure
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start rspamd: $status"
  exit $status
fi

# Start openSMTPd
smtpd -v
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start openSMTPd: $status"
  exit $status
fi

# Naive check runs checks once a minute to see if either of the processes exited.
# The container exits with an error if it detects that either of the processes has exited.
# Otherwise it loops forever, waking up every 60 seconds

while sleep 60; do
  ps aux |grep rspamd |grep -q -v grep
  RSPAMD_STATUS=$?
  ps aux |grep smtpd |grep -q -v grep
  SMTPD_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $RSPAMD_STATUS -ne 0 -o $SMTPD_STATUS -ne 0 ]; then
    echo "Either SMTPd or rSpamd has exited, stop the container; docker should restart it automatically."
    exit 1
  fi
done

