// views/onboarding/onboarding_page.dart
import 'package:digitaltwin/constants/ColorsSys.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String content;
  final bool reverse;
  final bool isLast;
  final VoidCallback? onLastPageButtonPressed;

  const OnboardingPage({
    Key? key,
    required this.image,
    required this.title,
    required this.content,
    this.reverse = false,
    this.isLast = false,
    this.onLastPageButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50, bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (!reverse)
            Column(
              children: <Widget>[
                FadeInUp(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(image),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          FadeInUp(
            duration: Duration(milliseconds: 900),
            child: Text(
              title,
              style: TextStyle(
                  color: ColorSys.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          FadeInUp(
            duration: Duration(milliseconds: 1200),
            child: Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorSys.gray,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
          ),
          if (reverse)
            Column(
              children: <Widget>[
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset(image),
                ),
              ],
            ),
          if (isLast)
            Column(
              children: [
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: onLastPageButtonPressed,
                  child: Text("Get Started",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: ColorSys.secoundry,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
