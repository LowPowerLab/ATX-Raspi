ATX-Raspi
=========

ATXRaspi is a smart power controller for RaspberryPi that allows you to have an external ATX style shutdown button

Copy the content of "rc.local" to your "/etc/rc.local"
The only needed code from this file is actually the line that starts up the shutdowncheck script

Copy the "shutdowncheck" bash script to your home directory - /home/pi/
Add the proper execute rights to shutdowncheck using chmod: sudo chmod 755 shutdowncheck

Connect your RaspberryPi to ATXRaspi:
GPIO7 (input to Pi) to outgoing arrow pin on ATXRaspi.
GPIO8 (output from Pi) goes to incoming arrow pin on ATXRaspi.
Connect power from output header (+/-) of ATXRaspi to GPIO power pins (5V/GND) on RaspberryPi.
Connect a momentary button and status LED to ATXRaspi (no resistor needed for LED).

Enjoy shutting down your Pi from the external button!
