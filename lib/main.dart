import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(RakshaSetuApp());
}

class RakshaSetuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RakshaSetu',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
