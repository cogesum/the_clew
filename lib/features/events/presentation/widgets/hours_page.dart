import 'package:clew_app/core/ui/app_color.dart';
import 'package:flutter/material.dart';

class HoursBadge extends StatelessWidget {
  const HoursBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.lightGreen,
            borderRadius: BorderRadius.circular(12 / 2),
          ),
        ),
        SizedBox(width: 16 * 0.5),
        Text(
          //AppLocalizations.of(context)!.hoursBadgeOpenedTill(hours),
          //AppLocalizations.of(context)!.hoursBadgeOpensAt(hours),
          '31 мая 20:00',
          style: TextStyle(
            fontSize: 14,
            color: AppColor.mainColor,
          ),
        )
      ],
    );
  }
}
