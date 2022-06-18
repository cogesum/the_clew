import 'package:clew_app/core/ui/app_color.dart';
import 'package:flutter/material.dart';

class StreetBadge extends StatelessWidget {
  final String street;
  const StreetBadge({Key? key, required this.street}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.streetview_rounded,
          size: 16,
        ),
        SizedBox(width: 16 * 0.5),
        Text(
          street,
          style: TextStyle(
            fontSize: 14,
            height: 20 / 14,
            color: AppColor.mainColor,
          ),
        )
      ],
    );
  }
}
