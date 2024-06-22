// views/intro_screen.dart
import 'package:digitaltwin/constants/ColorsSys.dart';
import 'package:digitaltwin/constants/Strings.dart';
import 'package:digitaltwin/views/home/home_screen.dart';
import 'package:digitaltwin/views/onboarding/onboarding.dart';
import 'package:digitaltwin/widgets/indecator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20, top: 20),
            child: TextButton(
              onPressed: _completeOnboarding,
              child: Text(
                'Skip',
                style: TextStyle(
                    color: ColorSys.gray,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            onPageChanged: (int page) {
              setState(() {
                currentIndex = page;
              });
            },
            controller: _pageController,
            children: <Widget>[
              OnboardingPage(
                image: 'assets/images/step-1.png',
                title: Strings.stepOneTitle,
                content: Strings.stepOneContent,
              ),
              OnboardingPage(
                reverse: true,
                image: 'assets/images/step-2.png',
                title: Strings.stepTwoTitle,
                content: Strings.stepTwoContent,
              ),
              OnboardingPage(
                image: 'assets/images/step-3.png',
                title: Strings.stepThreeTitle,
                content: Strings.stepThreeContent,
                isLast: true,
                onLastPageButtonPressed: _completeOnboarding,
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: Indicator.buildIndicator(currentIndex, 3),
            ),
          )
        ],
      ),
    );
  }

  void _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}
