// To parse this JSON data, do
//
//     final fcmModel = fcmModelFromMap(jsonString);

import 'dart:convert';

class FcmModel {
  FcmModel({
    required this.to,
    required this.notification,
    this.data,
  });

  String to;
  NotificationFCM notification;
  Object? data;

  factory FcmModel.fromJson(String str) => FcmModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FcmModel.fromMap(Map<String, dynamic> json) => FcmModel(
        to: json["to"],
        notification: NotificationFCM.fromMap(json["notification"]),
        data: json["data"],
      );

  Map<String, dynamic> toMap() => {
        "to": to,
        "notification": notification.toMap(),
        "data": data,
      };
}

class NotificationFCM {
  NotificationFCM({
    this.title,
    this.body,
    this.mutableContent = true,
    this.sound = "Tri-tone",
  });

  String? title;
  String? body;
  bool mutableContent;
  String sound;

  factory NotificationFCM.fromJson(String str) =>
      NotificationFCM.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationFCM.fromMap(Map<String, dynamic> json) => NotificationFCM(
        title: json["title"],
        body: json["body"],
        mutableContent: json["mutable_content"] ?? true,
        sound: json["sound"] ?? "Tri-tone",
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "body": body,
        "mutable_content": mutableContent,
        "sound": sound,
      };
}
