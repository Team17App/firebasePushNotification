// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CircularProgressWidget extends StatelessWidget {
  final Size size;
  const CircularProgressWidget({this.size = const Size(40.0, 40.0), super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: const FittedBox(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
