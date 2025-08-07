import 'package:flutter/material.dart';
import 'package:g6_assessment/app.dart';
import 'package:g6_assessment/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  runApp(MyApp());
}
