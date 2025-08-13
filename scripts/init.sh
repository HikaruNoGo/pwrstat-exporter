#!/bin/bash

/etc/init.d/pwrstatd start

# wait until the daemon is sleeping (connected to the UPS)
daemon_pid=$(cat /run/pwrstatd/pwrstatd.pid)
while [[ "$(cat /proc/$daemon_pid/status | grep State | awk '{print $2}')" != "S" ]]; do
  sleep 5
  echo "Waiting for a connected daemon"
done

# disable automations
/usr/sbin/pwrstat -lowbatt -capacity 0 -shutdown off -active off -runtime 0
/usr/sbin/pwrstat -pwrfail -active off -shutdown off

/app/pwrstat-exporter
