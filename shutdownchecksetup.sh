echo '#!/bin/bash

#This is GPIO 7 (pin 26 on the pinout diagram).
#This is an input from ATXRaspi to the Pi.
#When button is held for ~3 seconds, this pin will become HIGH signalling to this script to poweroff the Pi.
SHUTDOWN=7
echo "$SHUTDOWN" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio$SHUTDOWN/direction

#This is GPIO 8 (pin 24 on the pinout diagram).
#This is an output from Pi to ATXRaspi and signals that the Pi has booted.
#This pin is asserted HIGH as soon as this script runs (by writing "1" to /sys/class/gpio/gpio8/value)
BOOT=8
echo "$BOOT" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio$BOOT/direction
echo "1" > /sys/class/gpio/gpio$BOOT/value

echo "ATXRaspi shutdown script started: asserted pins ($SHUTDOWN=input,LOW; $BOOT=output,HIGH). Waiting for GPIO$SHUTDOWN to become HIGH..."

#This loop continuously checks if the shutdown button was pressed on ATXRaspi (GPIO7 to become HIGH), and issues a shutdown when that happens.
#It sleeps as long as that has not happened.
while [ 1 ]; do
  shutdownSignal=$(cat /sys/class/gpio/gpio$SHUTDOWN/value)
  if [ $shutdownSignal = 0 ]; then
    /bin/sleep 0.5
  else
    sudo poweroff
  fi
done' > /etc/shutdowncheck.sh
sudo chmod 755 /etc/shutdowncheck.sh
sudo sed -i '$ i /etc/shutdowncheck.sh &' /etc/rc.local