import 'package:digitaltwin/views/home/home_screen.dart';
import 'package:digitaltwin/views/home/introScreens.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: seenOnboarding ? HomeScreen() : IntroScreen(),
  ));
}
