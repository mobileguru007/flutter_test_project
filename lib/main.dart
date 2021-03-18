import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'app.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
