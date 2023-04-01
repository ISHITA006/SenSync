# SenSync

An app that detects sensory overload in individuals with autism and links them with their caregiver to help them better! Solution for Google Developer Solution Challenge

**NOTE: 
The individual components: fetching health data in the background from the frontend as well as the model prediction are fully functional separately but are not currently integrated due to an end moment error.

## Running the project

* In order to run all functionalities of the application and run the application on a physical iPhone device, the project needs to be run using Xcode on a MacBook.

1. Install Flutter version 3.7.6 on your macbook device (uses Dart 2.19.3).

2. Install Xcode version 14.2 IDE on your macbook device.

3. Enable developer mode on your iphone and resart your debugging device.

4. Open the project in Visual Studio Code IDE.

5. Go to "ios" folder inside the project directory, right click, and select "Open in Xcode" option. 

![image](https://user-images.githubusercontent.com/84574733/229269569-236725ce-e934-4c2f-aeaf-ede191abeef6.png)

7. Connect your iPhone to your MacBook using a USB or USB-c cable (data transfer cable).

7. Select your iPhone as the debbuging device on Xcode.

![image](https://user-images.githubusercontent.com/84574733/229269592-7fdd9f2a-3b1e-4915-8a7f-45938689a763.png)


8. Go to iPhone Settings, Go to VPN and Device Management and Trust apps from developer "Apple development {appleid} {unique code}".

9. Click on "run" button in xcode.

The application runs!!

* To check the background processing code on development mode, go to Xcode menu, select "Debug" and click on "Simulate Background Fetch".

Enjoy!


