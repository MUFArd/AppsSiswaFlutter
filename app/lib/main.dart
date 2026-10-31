import 'package:flutter/material.dart';

import 'page/LoginPage.dart';
import 'page/DashboardPage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold( 
        body: SafeArea(
          child: const PageLogin()
        )
      )
    );
  }
}
