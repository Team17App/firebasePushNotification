import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  /// Mode desktop
  final Widget? desktopScreen;

  /// Mode mobile
  final Widget? mobileScreen;

  const ResponsiveWidget({
    Key? key,
    this.desktopScreen,
    this.mobileScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 600) {
      return desktopScreen ?? mobileScreen ?? const SizedBox.shrink();
    }

    return mobileScreen ?? desktopScreen ?? const SizedBox.shrink();
  }
}
