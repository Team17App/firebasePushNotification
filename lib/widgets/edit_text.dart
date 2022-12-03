import 'dart:async';

import 'package:flutter/material.dart';

class EditTextWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final void Function()? suffixPressed;
  final void Function(String)? onSubmitted;
  final StreamController<bool>? stream;
  final Size sizeSuffixIcon;
  final Widget? suffixIcon;

  const EditTextWidget(
      {this.controller,
      this.hintText = '',
      this.suffixPressed,
      this.stream,
      this.sizeSuffixIcon = const Size(20.0, 20.0),
      this.suffixIcon,
      this.onSubmitted,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        suffixIcon: IconButton(
          onPressed: suffixPressed,
          icon: StreamBuilder<bool>(
              stream: stream?.stream,
              initialData: false,
              builder: (cotnext, snap) {
                return snap.data!
                    ? SizedBox(
                        width: sizeSuffixIcon.width,
                        height: sizeSuffixIcon.height,
                        child: const FittedBox(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : suffixIcon ?? const SizedBox();
              }),
        ),
      ),
      onSubmitted: onSubmitted,
    );
  }
}
