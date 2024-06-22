// widgets/indicator.dart
import 'package:digitaltwin/constants/ColorsSys.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final bool isActive;

  const Indicator({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 30 : 6,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          color: ColorSys.secoundry, borderRadius: BorderRadius.circular(5)),
    );
  }

  static List<Widget> buildIndicator(int currentIndex, int count) {
    List<Widget> indicators = [];
    for (int i = 0; i < count; i++) {
      indicators.add(Indicator(isActive: currentIndex == i));
    }
    return indicators;
  }
}
