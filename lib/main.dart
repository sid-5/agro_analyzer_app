import 'package:agro_analyzer_app/Screens/SettingsScreen.dart';
import 'package:flutter/material.dart';
import 'Screens/HomeScreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'first',
      routes: {
        'first':(context)=> HomePage(),
        'second':(context)=> ProfilePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

