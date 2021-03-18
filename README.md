# flutter_test_project

Flutter test for Tanveer UI Islam

## Documentation

- Design<br>
    Customer Registration screen
    ============================
    [IMEI]		 ____________ [auto-populated by default. If not available, let user enter it.]<br>
    [First name] ____________<br>
    [Last name]  ____________
    [DoB]        ____________ [Calendar, Date format = dd/MM/yyyy]<br>
    [Passport #] ____________ [Visible and mandatory ONLY when person is 18+]<br>
    [Email]      ____________<br>
    [Picture]    ____________ [Capture from Camera]<br>

                        [Save]
- Project Structure<br>
    I built MyApp class for main UI.
    For storing user information, I made userModel.dart.
- Flutter 3rd party plugins<br>
    [imei_plugin](https://pub.dev/packages/imei_plugin) to get device IMEI.<br>
    [image_picker](https://pub.dev/packages/image_picker) to capture/pick an image<br>
    [geolocator](https://pub.dev/packages/geolocator) to fetch device location.<br>
    [sqflite](https://pub.dev/packages/sqflite) to save/fetch user models to/from SQLite database.<br>
- Screenshots<br>
    ![Screenshot1](https://github.com/mobileguru007/flutter_test_project/blob/master/device-2021-03-18-135403.png) ![Screenshot2](https://github.com/mobileguru007/flutter_test_project/blob/master/device-2021-03-18-135432.png)
    ![Screenshot3](https://github.com/mobileguru007/flutter_test_project/blob/master/device-2021-03-18-140247.png) ![Screenshot4](https://github.com/mobileguru007/flutter_test_project/blob/master/device-2021-03-18-135845.png)
- Android APK<br>
  <a id="raw-url" href="https://github.com/mobileguru007/flutter_test_project/blob/master/app-release.apk">Download Apk</a>
