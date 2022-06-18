import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class MyLocationWidget extends StatefulWidget {
  const MyLocationWidget({Key? key}) : super(key: key);

  @override
  State<MyLocationWidget> createState() => _MyLocationWidgetState();
}

class _MyLocationWidgetState extends State<MyLocationWidget> {
  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      glowColor: Colors.blue,
      endRadius: 30.0,
      child: Material(
        elevation: 8.0,
        shape: const CircleBorder(),
        child: CircleAvatar(
          backgroundColor: Colors.grey[100],
          child: const Icon(Icons.circle),
          radius: 13.0,
        ),
      ),
    );
  }
}
