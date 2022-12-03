import 'package:flutter/material.dart';

class DialogSheetWidgets extends StatefulWidget {
  /// this text is title from dialog (Optional)
  final String? title;

  /// list widgets from dialog
  final List<Widget> children;

  const DialogSheetWidgets({this.title, this.children = const [], super.key});

  @override
  State<DialogSheetWidgets> createState() => _DialogSheetWidgetsState();
}

class _DialogSheetWidgetsState extends State<DialogSheetWidgets> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).dialogBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Stack(fit: StackFit.expand, children: [
        // list widgets
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.children,
          ),
        ),
        // title
        if (widget.title != null)
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              color: Theme.of(context).dialogBackgroundColor,
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              child: Text(
                widget.title!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ]),
    );
  }
}
