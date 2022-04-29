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

class ChatTile extends StatelessWidget {

  //final TextEditingController _editingController = TextEditingController();
  //final FocusNode _focusNode = FocusNode();
  final TextStyle textStyle = const TextStyle(color: Colors.white);

  final Chat chat;
  final uid = "";

  const ChatTile({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
      appBar: AppBar(
        title: const Text('Chatter'),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,

                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CustomPaint(
                          painter: CustomChatBubble(isOwn: false),
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Message from someone else \n Says sometihngs',
                                style: textStyle,
                              ))),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CustomPaint(
                          painter:
                          CustomChatBubble(color: Colors.grey, isOwn: false),
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              child: const FlutterLogo())),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CustomPaint(
                          painter:
                          CustomChatBubble(color: Colors.green, isOwn: true),
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'Message from me',
                                style: textStyle,
                              ))),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.withOpacity(0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          controller: _editingController,
                          focusNode: _focusNode,
                          decoration:
                          const InputDecoration(hintText: 'Say something...'),
                        ),
                      ),
                      IconButton(
                          icon: const Icon(
                            Icons.send,
                            size: 30,
                          ),
                          onPressed: () {
                            print(_editingController.text);
                          })
                    ],
                  ),
                ))
          ],
        ),
      ),
    );*/

    late Widget userChatTile;

    if (uid == chat.senderId){
      userChatTile = Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                CustomPaint(
                    painter: CustomChatBubble(color: Colors.blue ,isOwn: true),
                    child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          chat.message,
                          style: textStyle,
                        )
                    )
                ),
              ],
            ),
            Align(
              child: Text(chat.time.toString()),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
            Align(
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Text(
                    chat.senderId,
                    style: textStyle,
                  )
              ),
              alignment: Alignment.centerLeft,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CustomPaint(
                  painter: CustomChatBubble(color: Colors.blue ,isOwn: false),
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        chat.message,
                        style: textStyle,
                      )
                  ),
                ),
              ],
            ),
            Align(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Text(
                  chat.time.toString(),
                  style: textStyle,
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