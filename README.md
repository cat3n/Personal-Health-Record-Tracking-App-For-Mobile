# Personal-Health-Record-Tracking-App-For-Mobile
This project is about a mobile application in Flutter / Dart with some health tracking records.

##extra steps you need to take: <br />
1-> you need to go to the ..\android\app\src\main\AndroidManifest.xml and add the following 3 lines:<br />
```
  <uses-permission android:name="android.permission.CAMERA"/><br />
  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/><br />
  <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```
<br />
for the camera and photo library access permission handling in android phones <br />


and for the iphones you need to go to ..\ios\Runner\Info.plist and inside the "<dict> category add: <br />
    ```
    <key>NSCameraUsageDescription</key> <br />
    <string>We need to access your camera to upload photos</string> <br />
    <key>NSPhotoLibraryUsageDescription</key> <br />
    <string>We need to access your photo library to upload images</string>" <br />
    ```

    !! If you want to change any icon etc just change the assets folder and edit the pubspec.yaml correspondingly . Once you do that run "pub get"  !!

   The username and password (as the project is right now) you need to control in the form is: Username: jsmith Password: phrpassword
