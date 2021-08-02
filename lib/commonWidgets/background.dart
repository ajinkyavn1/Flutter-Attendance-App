
import 'package:flutter/material.dart';
import 'package:untitled1/constants/constants.dart';

class BackgroundContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context: context, divideBy: 3),
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.topCenter,
          fit: BoxFit.cover,
          image: AssetImage('assets/images/bg.png'),
        ),
      ),
    );
  }
}
