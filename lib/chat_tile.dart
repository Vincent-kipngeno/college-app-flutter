import 'package:flutter/material.dart';

import 'models/chat.dart';

class CustomChatBubble extends CustomPainter {
  CustomChatBubble({required this.color, required this.isOwn});

  final Color color;
  final bool isOwn;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    Path paintBubbleTail() {
      late Path path;
      if (!isOwn) {
        path = Path()
          ..moveTo(5, size.height - 5)
          ..quadraticBezierTo(-5, size.height, -16, size.height - 4)
          ..quadraticBezierTo(-5, size.height - 5, 0, size.height - 17);
      }
      if (isOwn) {
        path = Path()
          ..moveTo(size.width - 6, size.height - 4)
          ..quadraticBezierTo(
              size.width + 5, size.height, size.width + 16, size.height - 4)
          ..quadraticBezierTo(
              size.width + 5, size.height - 5, size.width, size.height - 17);
      }
      return path;
    }

    final RRect bubbleBody = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(16));
    final Path bubbleTail = paintBubbleTail();

    canvas.drawRRect(bubbleBody, paint);
    canvas.drawPath(bubbleTail, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class ChatTile extends StatefulWidget{

  const ChatTile({Key? key, required this.chat, required this.uid, required this.username}) : super(key: key);

  final Chat chat;
  final String uid, username;


  @override
  State<ChatTile> createState() => ChatTileState();

}

class ChatTileState extends State<ChatTile> {

  final TextStyle textStyle = const TextStyle(color: Colors.white);
  late Chat chat;
  String uid = "";
  String username = "";

  @override
  void initState() {
    super.initState;
    chat = widget.chat;
    uid = widget.uid;
    username = widget.username;
  }

  @override
  Widget build(BuildContext context){
    late Widget userChatTile;

    if (uid == chat.senderId){
      userChatTile = Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
                fit: FlexFit.loose,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(left: 15, right: 10),
                        child: CustomPaint(
                          painter: CustomChatBubble(color: const Color(0xff253412) ,isOwn: true,),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              chat.message,
                              style: textStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
            Align(
              child: Text(
                chat.formattedTime(),
                style: const TextStyle(color: Colors.grey),
              ),
              alignment: Alignment.centerRight,
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      );
    }

    if (uid != chat.senderId){
      userChatTile = Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Text(
                    username,
                    style: const TextStyle(color: Colors.grey),
                  )
              ),
              alignment: Alignment.centerLeft,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(right: 15, left: 10),
                      child: CustomPaint(
                        painter: CustomChatBubble(color: const Color(0xff379417) ,isOwn: false,),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            chat.message,
                            style: textStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Text(
                  chat.formattedTime(),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              alignment: Alignment.centerLeft,
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      );
    }

    return userChatTile;
  }
}