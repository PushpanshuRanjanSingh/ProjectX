import 'package:flutter/material.dart';
import 'package:projectx/constants/app_theme.dart';
import 'package:projectx/ui/contact_add.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ProjectX',
      theme: themeData,
      darkTheme: themeDataDark,
      home: ContactEditTextField(),
    );
  }
}
