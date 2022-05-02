import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

DatabaseReference userRef = FirebaseDatabase.instance.ref("users");

class Chat{

  Chat();

  Chat.construct({required this.message, required this.senderId, required this.groupCode, required this.time, required this.userName});
  Chat.fromMap(Map chat)
      : message = chat["message"],
        senderId = chat["senderId"],
        groupCode = chat["groupCode"],
        time = chat["time"],
        userName = chat["username"];

  late String message, senderId, groupCode, userName;
  late int time;

  void setMessage(String? value) {
    message = value?? "";
  }

  void setSenderId(String? value) {
    senderId = value?? "";
  }

  void setGroupCode(String? value) {
    groupCode = value?? "";
  }

  void setTime(int? value) {
    time = value!;
  }

  String formattedTime(){
    return DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  Map<String, dynamic> toMap(){
    Map<String,dynamic> chat = HashMap();
    chat["message"] = message;
    chat["senderId"] = senderId;
    chat["groupCode"] = groupCode;
    chat["time"] = time;
    chat["username"] = userName;
    return chat;
  }
}