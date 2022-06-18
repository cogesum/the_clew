import 'package:clew_app/features/user/presentation/widgets/achive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/app_color.dart';
import '../../../auth_pages/presentation/bloc/bloc/auth_bloc.dart';

class UserProfile extends StatefulWidget {
  const UserProfile(
      {Key? key,
      required this.email,
      required this.username,
      required this.points})
      : super(key: key);
  final String username;
  final String email;
  final int points;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Профиль",
          style: TextStyle(
              color: AppColor.mainColor,
              fontSize: 20,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: AppColor.secondColor,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignOut());
              },
              icon: const Icon(
                Icons.exit_to_app,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              painter: HeaderCurvedContainer(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.mainColor, width: 5),
                    shape: BoxShape.circle,
                    color: AppColor.mainColor,
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/witcher.jpg'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NameAndEmailUserInfo(
                    username: widget.username,
                    email: widget.email,
                  ),
                ),
                PointsNumber(
                  points: widget.points,
                ),
                AchivesWidget(),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 150, left: 174),
            //   child: CircleAvatar(
            //     maxRadius: 15,
            //     backgroundColor: Colors.blue[200],
            //     child: IconButton(
            //       icon: const Icon(
            //         Icons.edit,
            //         color: Colors.white,
            //         size: 15,
            //       ),
            //       onPressed: () {},
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = AppColor.secondColor;
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 255, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class NameAndEmailUserInfo extends StatelessWidget {
  const NameAndEmailUserInfo(
      {Key? key, required this.username, required this.email})
      : super(key: key);
  final String username;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          username,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold),
        ),
        Text(
          email,
          style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class PointsNumber extends StatelessWidget {
  const PointsNumber({Key? key, required this.points}) : super(key: key);
  final int points;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Text(
            points.toString(),
            style: const TextStyle(
                color: AppColor.mainColor,
                fontSize: 20,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold),
          ),
        ),
        width: MediaQuery.of(context).size.width / 2,
        height: 50,
        decoration: BoxDecoration(
          color: AppColor.secondColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
