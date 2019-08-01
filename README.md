ATXRaspi
=========

ATXRaspi is a smart power controller for RaspberryPi that allows you to poweroff or reboot your Pi from [a momentary switch (with LED status)](https://lowpowerlab.com/shop/product/118).

## For the latest revision and details please see the [official ATXRaspi Guide](https://lowpowerlab.com/guide/atxraspi/).

### Overview and setup video (click to watch):
[![ATXRaspi overview](https://farm8.staticflickr.com/7616/16572327060_3dd6c95d24.jpg)](http://www.youtube.com/watch?v=w4vSTq2WhN8)

### Wiring your Pi to [ATXRaspi](http://www.lowpowerlab.com/atxraspi)
- GPIO7 (input to Pi) to outgoing arrow pin on ATXRaspi.
- GPIO8 (output from Pi) goes to incoming arrow pin on ATXRaspi.
- Connect power from output header (+/-) of ATXRaspi to GPIO power pins (5V/GND) on RaspberryPi (or straight through USB if you have that soldered).
- Connect a momentary button and status LED to ATXRaspi (no resistor needed for LED). You can also get LED integrated momentary switches [from the LowPowerLab webshop](https://lowpowerlab.com/shop/LEDSwitch).

### Quick setup steps (raspbian):
Log into your Pi an run the setup script, then remove it and reboot:
- `sudo wget https://raw.githubusercontent.com/LowPowerLab/ATX-Raspi/master/shutdownchecksetup.sh`
- `sudo bash shutdownchecksetup.sh`
- `sudo rm shutdownchecksetup.sh`
- `sudo reboot`

### For OpenElec and other details please see the [official guide](https://lowpowerlab.com/guide/atxraspi/).

### Enjoy shutting down and rebooting your Pi from the external button!
