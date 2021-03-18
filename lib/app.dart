import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart' as Path;
import 'extension.dart';
import 'userModel.dart';
import 'package:sqflite/sqflite.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final String title = 'Flutter Test App For Tanveer Ul Islam';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime dob = DateTime(2000);
  final TextEditingController _imeiController = new TextEditingController();
  final TextEditingController _fnController = new TextEditingController();
  final TextEditingController _lnController = new TextEditingController();
  final TextEditingController _pspController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  File _image = null;
  double latitude = 00.00000;
  double longitude = 00.00000;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getImei();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error(
            'Location permissions are denied');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude;
    longitude = position.longitude;
  }

  Future<void> getImei() async {
    String platformImei;
    try {
      platformImei =
      await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      List<String> multiImei = await ImeiPlugin.getImeiMulti();
      if (multiImei.length > 1) platformImei = multiImei[0];
      print(multiImei);
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _imeiController.text = platformImei;
    });
  }

  Future<void> onSave() async {
    var imei = _imeiController.text;
    var firstName = _fnController.text;
    var lastName = _lnController.text;
    var passportId = _pspController.text;
    var dobStr = DateFormat('yyyy/MM/dd').format(dob);
    var email = _emailController.text;
    var photo = _image.absolute.path;
    var deviceName = "Other";
    if (Platform.isAndroid)
      deviceName = "Android";
    else if (Platform.isIOS)
      deviceName = "iOS";
    else if (Platform.isMacOS)
      deviceName = "MacOS";
    else if (Platform.isLinux)
      deviceName = "Linux";
    else if (Platform.isWindows) deviceName = "Windows";
    var newUser = User(
        imei,
        firstName,
        lastName,
        passportId,
        dobStr,
        email,
        photo,
        deviceName,
        latitude,
        longitude);
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = Path.join(databasesPath, 'demo.db');
    Database database;
    if (!await databaseExists(path)) {
      // open the database
      database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
            // When creating the db, create the table
            await db.execute(
                'CREATE TABLE Users ('
                    'imei TEXT, '
                    'firstName TEXT, '
                    'lastName TEXT, '
                    'passportId TEXT, '
                    'dob TEXT, '
                    'email TEXT, '
                    'photo TEXT, '
                    'deviceName TEXT, '
                    'latitude DOUBLE, '
                    'longitude DOUBLE)');
          });
      print('create table Users success');
    } else {
      database = await openDatabase(path);
    }
    print('db open success');

    await database.insert(
      'Users',
      newUser.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('db insert success');
    _showToast('Success', 'Successfully stored User information!');
    clearFields();
  }

  void clearFields() {
    _fnController.text = "";
    _lnController.text = "";
    _pspController.text = "";
    _emailController.text = "";
    setState(() {
      dob = DateTime(2000);
      _image = null;
    });
  }

  Future<bool> databaseExists(String path) =>
      databaseFactory.databaseExists(path);

  Future<void> dobClicked() async {
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime(2000),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != dob) {
      setState(() {
        dob = pickedDate;
      });
    }
  }

  _imgFromCamera() async {
    final image = await picker.getImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  _imgFromGallery() async {
    final image = await picker.getImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showToast(String title, String body) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(body),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('IMEI'),
                  TextFormField(
                    controller: _imeiController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your IMEI',
                    ),
                    validator: (String value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Text('First Name'),
                  TextFormField(
                    controller: _fnController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your First name',
                    ),
                    validator: (String value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Last Name'),
                  TextFormField(
                    controller: _lnController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your Last name',
                    ),
                    validator: (String value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Date of Birth'),
                  TextButton(
                      onPressed: dobClicked,
                      child: Text(DateFormat('yyyy/MM/dd').format(dob))),
                  Visibility(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Passport(Only for 18+) #'),
                        TextFormField(
                          controller: _pspController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your passport ID',
                          ),
                          validator: (String value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    visible: (DateTime
                        .now()
                        .year - dob.year) > 18,
                  ),
                  SizedBox(height: 10),
                  Text('Email'),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your Email',
                    ),
                    validator: (String value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (!value.isValidEmail()) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Picture'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Color(0xffFDCF09),
                          child: _image != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              _image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.fitHeight,
                            ),
                          )
                              : Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(50)),
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
                            if (dob.year == DateTime
                                .now()
                                .year &&
                                dob.month == DateTime
                                    .now()
                                    .month &&
                                dob.day == DateTime
                                    .now()
                                    .day) {
                              _showToast(
                                  'Validation', 'Please choose your DOB');
                              return;
                            }
                            if (_image == null) {
                              _showToast(
                                  'Validation', 'Please choose your photo');
                              return;
                            }
                            if (_formKey.currentState.validate()) {
                              // Process data.
                              onSave();
                            }
                          },
                          child: const Text('Save'),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}