# SenSync

An app that detects sensory overload in individuals with autism and links them with their caregiver to help them better! Solution for Google Developer Solution Challenge 2023.

**NOTE: 
The individual components: fetching health data in the background from the frontend as well as the model prediction are fully functional separately but are not currently integrated due to an end moment error.

## Running the project

* In order to run all functionalities of the application and run the application on a physical iPhone device, the project needs to be run using Xcode on a MacBook.

1. Install Flutter version 3.7.6 on your macbook device (uses Dart 2.19.3).

2. Install Xcode version 14.2 IDE on your macbook device.

3. Enable developer mode on your iphone and resart your debugging device.

4. Open the project in Visual Studio Code IDE.

5. Run command "flutter clean" in the project directory.

6. Run command "flutter pub get" in the project directory.

7. Go to "ios" folder inside the project directory, right click, and select "Open in Xcode" option. 

![image](https://user-images.githubusercontent.com/84574733/229269569-236725ce-e934-4c2f-aeaf-ede191abeef6.png)

8. Connect your iPhone to your MacBook using a USB or USB-c cable (data transfer cable).

9. Select your iPhone as the debbuging device on Xcode.

![image](https://user-images.githubusercontent.com/84574733/229269592-7fdd9f2a-3b1e-4915-8a7f-45938689a763.png)

10. Click on "run" button in Xcode (build will not run if installing the app for the first time on your phone).

11. Go to iPhone Settings, Go to VPN and Device Management and Trust apps from developer "Apple development {appleid} {unique code}".

12. Click on "run" button in xcode again.

The application runs!!

* The app runs code in the background to fetch user health data and pass it to the server.
* To check the background processing code on development mode, go to Xcode menu, select "Debug" and click on "Simulate Background Fetch".

Enjoy!

** NOTE: In case the build fails, try running "flutter clean" in the project directory.Then delete "Pods" folder and "Podfile.lock" file inside the ios directory. Then on the terminal run the following commands in sequence: "cd ios", "pod install" and "pod update". Try reopening the ios folder in Xcode and follow from step 8 onwards.


