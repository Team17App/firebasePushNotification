import 'dart:async';
import 'dart:convert';
import 'package:firebase_push_notification/api-services/apiServices.dart';
import 'package:flutter/material.dart';

import 'package:firebase_push_notification/config/constants.dart';
import 'package:firebase_push_notification/models/fcm_model.dart';
import 'package:firebase_push_notification/utilities/utilities.dart';
import 'package:firebase_push_notification/widgets/widgets.dart';

import 'package:code_text_field/code_text_field.dart';

import '../../config/config.dart';

class HomeDesktop extends StatefulWidget {
  const HomeDesktop({super.key});

  @override
  State<HomeDesktop> createState() => _HomeDesktopState();
}

class _HomeDesktopState extends State<HomeDesktop> {
  late CodeController _codeController;

  List<TextEditingController> controllers = [];
  List<StreamController<bool>> loading = [];
  List<String> hints = [
    "Key Authentification",
    "Token FCM send",
    "Title notification",
    "Body Notification",
    "data"
  ];

  bool isShowKey = false, isNullData = false, isData = false;

  @override
  void initState() {
    controllers = List<TextEditingController>.generate(
      4,
      (i) => TextEditingController(),
    );
    loading = List<StreamController<bool>>.generate(
      4,
      (i) => StreamController.broadcast(),
    );
    super.initState();
    const source = "{\n  \"key\":\"value\"\n}";
    // Instantiate the CodeController
    _codeController = CodeController(
      text: source,
    );
    initShared();
  }

  @override
  void dispose() {
    for (var ctr in controllers) {
      ctr.dispose();
    }
    for (var stream in loading) {
      stream.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        shrinkWrap: true,
        children: [
          Container(
            height: 56,
            width: double.maxFinite,
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            margin: const EdgeInsets.only(bottom: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            child: const Text(
              APP_NAME,
              style: TextStyle(
                fontFamily: 'SourceCodePro',
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          ListTile(
            title: Row(
              children: [
                const Text('Setting: Empty text will be sent as '),
                Text(
                  ' ${isNullData ? "empty" : "null"}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            trailing: Switch(
              value: isNullData,
              onChanged: (v) => setState(() {
                isNullData = v;
              }),
            ),
          ),
          ListTile(
            title: Text(isShowKey ? 'Show Key Atuh' : 'Hide Key Auth'),
            trailing: Switch(
              value: isShowKey,
              onChanged: (v) => setState(() {
                isShowKey = v;
              }),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0).copyWith(top: 0),
            child: Column(children: [
              for (int i = isShowKey ? 0 : 1; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: EditTextWidget(
                    hintText: hints[i],
                    controller: controllers[i],
                    suffixIcon: Icon(
                      isShowKey ? Icons.save_as_outlined : Icons.save_alt,
                    ),
                    suffixPressed: () => savedData(i),
                    stream: loading[i],
                  ),
                ),
              const Divider(),
              ListTile(
                title: Text("field ${hints[4]}"),
                subtitle: const Text(
                    'The "data" field will be sent as null if this option is unchecked.'),
                trailing: Switch(
                  value: isData,
                  onChanged: (v) => setState(() {
                    isData = v;
                  }),
                ),
              ),
              if (isData)
                CodeField(
                  controller: _codeController,
                  textStyle: const TextStyle(fontFamily: 'SourceCodePro'),
                ),
              const Divider(),
              ElevatedButton(
                onPressed: funContinue,
                child: const Text('Continue'),
              ),
            ]),
          ),
        ]);
  }

  initShared() async {
    final key = await SharedPrefs.getString(shared_key);
    final token = await SharedPrefs.getString(shared_token);
    final title = await SharedPrefs.getString(shared_title);
    final body = await SharedPrefs.getString(shared_body);

    List<String> shareds = [key, token, title, body];
    for (var i = 0; i < 4; i++) {
      controllers[i].text = shareds[i];
    }
    setState(() {
      isShowKey = key.isEmpty;
    });
  }

  savedData(int index) async {
    List<String> shareds = [
      shared_key,
      shared_token,
      shared_title,
      shared_body
    ];
    loading[index].add(true);
    await SharedPrefs.setString(shareds[index], controllers[index].text);
    debugPrint('Saved => ${shareds[index]}');
    loading[index].add(false);
  }

  funContinue() {
    // ignore: prefer_typing_uninitialized_variables
    var data;

    final titlex = controllers[2].text.trim();
    final bodyx = controllers[3].text.trim();

    try {
      data = jsonDecode(_codeController.text);
    } catch (e) {
      debugPrint('$e');
    }
    final model = FcmModel(
      to: controllers[1].text,
      notification: NotificationFCM(
        title: (isNullData || titlex.isNotEmpty) ? titlex : null,
        body: (isNullData || bodyx.isNotEmpty) ? bodyx : null,
      ),
      data: isData ? data : null,
    );

    final body = model.toMap();
    final source = model.toJson();

    //debugPrint(source);
    DialogUtils(context, title: 'Preview').dialogPopUpCode(
      onPressed: () => funSendData(body),
      source: source
          .replaceAll("{", "\n{\n")
          .replaceAll(",", ",\n")
          .replaceAll("}", "\n}"),
    );
  }

  funSendData(Map<String, dynamic> body) async {
    if (controllers[0].text.isEmpty) return;

    // url
    final url = Uri.parse(urlFCM);
    // headers
    final header = ApiServices.headersAuthFirebase(controllers[0].text);

    final response = await ApiServices.POST(
      url: url,
      bodyy: body,
      header: header,
    );
    if (response == null) {
      // ignore: use_build_context_synchronously
      DialogUtils(context, title: 'Error').dialogSheetMsg(
        children: const [
          Text('Code: 404'),
          SizedBox(height: 10.0),
          Text('Not Response'),
          SizedBox(height: 10.0),
        ],
      );
      return;
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      // ignore: use_build_context_synchronously
      DialogUtils(context, title: 'Error').dialogSheet(
        children: [
          Text('Code: ${response.statusCode}'),
          const SizedBox(height: 10.0),
          Text('Response: ${response.body}'),
        ],
      );
      return;
    }

    // ignore: use_build_context_synchronously
    // ignore: use_build_context_synchronously
    DialogUtils(context).dialogSheetMsg(
      children: [
        Text('Code: ${response.statusCode}'),
        const SizedBox(height: 10.0),
        const Text('Notification completed'),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
