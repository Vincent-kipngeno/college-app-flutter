import 'dart:collection';

class Chat{

  Chat();

  Chat.construct({required this.message, required this.senderId, required this.groupCode, required this.time});
  Chat.fromMap(Map chat)
      : message = chat["message"],
        senderId = chat["senderId"],
        groupCode = chat["groupCode"],
        time = chat["time"];

  late String message, senderId, groupCode;
  late BigInt time;

  void setMessage(String? value) {
    message = value?? "";
  }

  void setSenderId(String? value) {
    senderId = value?? "";
  }

  void setGroupCode(String? value) {
    groupCode = value?? "";
  }

  void setTime(BigInt? value) {
    time = value!;
  }


  Map<String, dynamic> chatMap(){
    Map<String,dynamic> chat = HashMap();
    chat["message"] = message;
    chat["senderId"] = senderId;
    chat["groupCode"] = groupCode;
    chat["time"] = time;
    return chat;
  }
}