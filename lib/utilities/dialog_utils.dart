import 'package:code_text_field/code_text_field.dart';
import 'package:firebase_push_notification/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  /// this context is required
  final BuildContext context;

  /// this text is title from dialog (Optional)
  final String? title;

  DialogUtils(this.context, {this.title});

  dialogSheet({List<Widget> children = const []}) {
    return showModalBottomSheet(
      context: context,
      barrierColor: Colors.black12,
      backgroundColor: Colors.transparent,
      builder: (context) => DialogSheetWidgets(
        title: title,
        children: children,
      ),
    );
  }

  dialogSheetMsg({List<Widget> children = const []}) {
    return showModalBottomSheet(
      context: context,
      barrierColor: Colors.black12,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }

  dialogPopUpCode(
      {required String source, required void Function() onPressed}) {
    CodeController codeController = CodeController(
      text: source,
    );

    return showDialog(
      context: context,
      barrierColor: Colors.black45,
      builder: (context) => Scaffold(
        backgroundColor: Colors.black45,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // code
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CodeField(
                    controller: codeController,
                    readOnly: true,
                    textStyle: const TextStyle(fontFamily: 'SourceCodePro'),
                  ),
                ),
                const SizedBox(height: 20),
                Row(children: [
                  // cancel
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        width: double.maxFinite,
                        height: 50.0,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Text(
                          'CANCEL',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        onPressed();
                      },
                    ),
                  ),
                  // send
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        width: double.maxFinite,
                        height: 50.0,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Text(
                          'SEND',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        onPressed();
                      },
                    ),
                  ),
                ]),
              ]),
        ),
      ),
    );
  }
}
