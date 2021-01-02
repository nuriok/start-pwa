# start-pwa
A simple Android shell script to start Progressive Web Apps from command line


Usage
--------
1.	Create a Progressive Web App using a browser on the android device.
2.	Run the script from the device shell or via ADB command with the PWA name as a parameter:
```
./start-pwa.sh <web App Name>
```
If a bad name is provided, the script will return an error with a list of available web apps.


References
--------
This script was written with the help of information found at:
https://www.creationfactory.co/2020/04/building-kiosk-for-home-assistant-from_27.html
