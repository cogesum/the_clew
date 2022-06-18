import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  CustomText({Key? key, required this.spendPoints}) : super(key: key);
  int spendPoints;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Да',
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }
}
