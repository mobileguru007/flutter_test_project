# flutter_test_project

Flutter test for Tanveer UI Islam

## Documentation

- Design
    Customer Registration screen
    ============================
    [IMEI]		 ____________ [auto-populated by default. If not available, let user enter it.]
    [First name] ____________
    [Last name]  ____________
    [DoB]        ____________ [Calendar, Date format = dd/MM/yyyy]
    [Passport #] ____________ [Visible and mandatory ONLY when person is 18+]
    [Email]      ____________
    [Picture]    ____________ [Capture from Camera]

                        [Save]
- Project Structure
    I built MyApp class for main UI.
    For storing user information, I made userModel.dart.
- Flutter 3rd party plugins
    [imei_plugin](https://pub.dev/packages/imei_plugin) to get device IMEI.
    [image_picker](https://pub.dev/packages/image_picker) to capture/pick an image
    [geolocator](https://pub.dev/packages/geolocator) to fetch device location.
    [sqflite](https://pub.dev/packages/sqflite) to save/fetch user models to/from SQLite database.
- Screenshots
    ![Screenshot1](https://github.com/mobileguru007/flutter_test_project/blob/master/device-2021-03-18-135403.png) ![Screenshot2](https://github.com/mobileguru007/flutter_test_project/blob/master/device-2021-03-18-135432.png)
    ![Screenshot3](https://github.com/mobileguru007/flutter_test_project/blob/master/device-2021-03-18-140247.png) ![Screenshot4](https://github.com/mobileguru007/flutter_test_project/blob/master/device-2021-03-18-135845.png)
- Android APK
  <a id="raw-url" href="https://github.com/mobileguru007/flutter_test_project/blob/master/app-release.apk">Download Apk</a>
