import 'dart:collection';
import 'package:intl/intl.dart';


class Chat{

  Chat();

  Chat.construct({required this.message, required this.senderId, required this.groupCode, required this.time});
  Chat.fromMap(Map chat)
      : message = chat["message"],
        senderId = chat["senderId"],
        groupCode = chat["groupCode"],
        time = chat["time"];

  late String message, senderId, groupCode;
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
    return chat;
  }
}