#!/bin/bash

OPTION=$(whiptail --title "ATXRaspi/MightyHat shutdown/reboot script setup" --menu "\nChoose your script type option below:\n\n(Note: changes require reboot to take effect)" 15 78 4 \
"1" "Install INTERRUPT based script /etc/shutdownirq.py (recommended)" \
"2" "Install POLLING based script /etc/shutdowncheck.sh (classic)" \
"3" "Disable any existing shutdown script" 3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ]; then
    sudo sed -e '/shutdown/ s/^#*/#/' -i /etc/rc.local

    if [ $OPTION = 1 ]; then
      echo '#!/usr/bin/python
# ATXRaspi/MightyHat interrupt based shutdown/reboot script
# Script by Tony Pottier, Felix Rusu
import RPi.GPIO as GPIO
import os
import sys
import time

GPIO.setmode(GPIO.BCM) 

pulseStart = 0.0
REBOOTPULSEMINIMUM = 0.2	#reboot pulse signal should be at least this long (seconds)
REBOOTPULSEMAXIMUM = 1.0	#reboot pulse signal should be at most this long (seconds)
SHUTDOWN = 7							#GPIO used for shutdown signal
BOOT = 8								#GPIO used for boot signal

# Set up GPIO 8 and write that the PI has booted up
GPIO.setup(BOOT, GPIO.OUT, initial=GPIO.HIGH)

# Set up GPIO 7  as interrupt for the shutdown signal to go HIGH
GPIO.setup(SHUTDOWN, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

print "\n=========================================================================================="
print "   ATXRaspi shutdown IRQ script started: asserted pins (",SHUTDOWN, "=input,LOW; ",BOOT,"=output,HIGH)"
print "   Waiting for GPIO", SHUTDOWN, "to become HIGH (short HIGH pulse=REBOOT, long HIGH=SHUTDOWN)..."
print "=========================================================================================="
try:
	while True:	
		GPIO.wait_for_edge(SHUTDOWN, GPIO.RISING)
		shutdownSignal = GPIO.input(SHUTDOWN)
		pulseStart = time.time() #register time at which the button was pressed
		while shutdownSignal:
			time.sleep(0.2)
			if(time.time() - pulseStart >= REBOOTPULSEMAXIMUM):
				print "\n====================================================================================="
				print "            SHUTDOWN request from GPIO", SHUTDOWN, ", halting Rpi ..."
				print "====================================================================================="
				os.system("sudo poweroff")
				sys.exit()
			shutdownSignal = GPIO.input(SHUTDOWN)
		if time.time() - pulseStart >= REBOOTPULSEMINIMUM:
			print "\n====================================================================================="
			print "            REBOOT request from GPIO", SHUTDOWN, ", recycling Rpi ..."
			print "====================================================================================="
			os.system("sudo reboot")
			sys.exit()
		if GPIO.input(SHUTDOWN): #before looping we must make sure the shutdown signal went low
			GPIO.wait_for_edge(SHUTDOWN, GPIO.FALLING)
except:
	pass 
finally:
	GPIO.cleanup()' > /etc/shutdownirq.py
      sudo sed -i '$ i python /etc/shutdownirq.py &' /etc/rc.local
    elif [ $OPTION = 2 ]; then
      echo '#!/bin/bash
# ATXRaspi/MightyHat interrupt based shutdown/reboot script
# Script by Felix Rusu

#This is GPIO 7 (pin 26 on the pinout diagram).
#This is an input from ATXRaspi to the Pi.
#When button is held for ~3 seconds, this pin will become HIGH signalling to this script to poweroff the Pi.
SHUTDOWN=7
REBOOTPULSEMINIMUM=200      #reboot pulse signal should be at least this long
REBOOTPULSEMAXIMUM=600      #reboot pulse signal should be at most this long
echo "$SHUTDOWN" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio$SHUTDOWN/direction
#Added reboot feature (with ATXRaspi R2.6 (or ATXRaspi 2.5 with blue dot on chip)
#Hold ATXRaspi button for at least 500ms but no more than 2000ms and a reboot HIGH pulse of 500ms length will be issued
#This is GPIO 8 (pin 24 on the pinout diagram).
#This is an output from Pi to ATXRaspi and signals that the Pi has booted.
#This pin is asserted HIGH as soon as this script runs (by writing "1" to /sys/class/gpio/gpio8/value)
BOOT=8
echo "$BOOT" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio$BOOT/direction
echo "1" > /sys/class/gpio/gpio$BOOT/value

echo -e "\n=========================================================================================="
echo "   ATXRaspi shutdown POLLING script started: asserted pins ($SHUTDOWN=input,LOW; $BOOT=output,HIGH)"
echo "   Waiting for GPIO$SHUTDOWN to become HIGH (short HIGH pulse=REBOOT, long HIGH=SHUTDOWN)..."
echo "=========================================================================================="

#This loop continuously checks if the shutdown button was pressed on ATXRaspi (GPIO7 to become HIGH), and issues a shutdown when that happens.
#It sleeps as long as that has not happened.
while [ 1 ]; do
  shutdownSignal=$(cat /sys/class/gpio/gpio$SHUTDOWN/value)
  if [ $shutdownSignal = 0 ]; then
    /bin/sleep 0.2
  else  
    pulseStart=$(date +%s%N | cut -b1-13) # mark the time when Shutoff signal went HIGH (milliseconds since epoch)
    while [ $shutdownSignal = 1 ]; do
      /bin/sleep 0.02
      if [ $(($(date +%s%N | cut -b1-13)-$pulseStart)) -gt $REBOOTPULSEMAXIMUM ]; then
        echo -e "\n====================================================================================="
        echo "            SHUTDOWN request from GPIO", SHUTDOWN, ", halting Rpi ..."
        echo "====================================================================================="
        sudo poweroff
        exit
      fi
      shutdownSignal=$(cat /sys/class/gpio/gpio$SHUTDOWN/value)
    done
    #pulse went LOW, check if it was long enough, and trigger reboot
    if [ $(($(date +%s%N | cut -b1-13)-$pulseStart)) -gt $REBOOTPULSEMINIMUM ]; then 
      echo -e "\n====================================================================================="
      echo "            REBOOT request from GPIO", SHUTDOWN, ", recycling Rpi ..."
      echo "====================================================================================="
      sudo reboot
      exit
    fi
  fi
done' > /etc/shutdowncheck.sh
sudo chmod +x /etc/shutdowncheck.sh
sudo sed -i '$ i /etc/shutdowncheck.sh &' /etc/rc.local
    fi
    
    echo "You chose option" $OPTION ": All done!"
else
    echo "Shutdown/Reboot script setup was aborted."
fi