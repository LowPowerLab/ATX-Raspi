ATXRaspi
=========

ATXRaspi is a smart power controller for RaspberryPi that allows you to poweroff your Pi from [a momentary switch (with LED status)](https://lowpowerlab.com/shop/LEDSwitch).

##Wiring your Pi to [ATXRaspi](http://www.lowpowerlab.com/atxraspi)
- GPIO7 (input to Pi) to outgoing arrow pin on ATXRaspi.
- GPIO8 (output from Pi) goes to incoming arrow pin on ATXRaspi.
- Connect power from output header (+/-) of ATXRaspi to GPIO power pins (5V/GND) on RaspberryPi (or straight through USB if you have that soldered).
- Connect a momentary button and status LED to ATXRaspi (no resistor needed for LED). You can also get LED integrated momentary switches [from the LowPowerLab webshop](https://lowpowerlab.com/shop/LEDSwitch).

##Setup/install (recommended):
Log into your Pi an run these commands once:
- sudo wget https://raw.githubusercontent.com/LowPowerLab/ATX-Raspi/master/shutdownchecksetup.sh
- sudo bash shutdownchecksetup.sh
- sudo rm shutdownchecksetup.sh
- sudo reboot
<br/>The last command will remove the setup script since it's no longer necessary.

###Enjoy shutting down your Pi from the external button!

##Old setup/install method:
Copy the content of "rc.local" to your "/etc/rc.local"
The only needed code from this file is actually the line that starts up the shutdowncheck script
Copy the "shutdowncheck" bash script to your home directory - /home/pi/
Add the proper execute rights to shutdowncheck using chmod: sudo chmod 755 shutdowncheck
