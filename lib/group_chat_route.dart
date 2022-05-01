import 'dart:async';

import 'package:college_app/services/sqLite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


import 'chat_tile.dart';
import 'models/chat.dart';

Icon emoji = const Icon(Icons.emoji_emotions_outlined, size: 30 , color: Color(0xffA8B0A2));
ImageIcon sendBtn = const ImageIcon(AssetImage("assets/images/send_button.png"), size: 30,);

class ChatRoute extends StatefulWidget{
  const ChatRoute({Key? key, required this.groupCode}) : super(key: key);

  final String groupCode;

  @override
  _ChatRouteState createState() => _ChatRouteState();

}
class _ChatRouteState extends State<ChatRoute>{

  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late List<Chat> _chats = <Chat>[];
  late String _code;
  late SqLiteDbHelper _sqLiteDb;

  late DatabaseReference _chatRef;
  late String _messageSenderId;
  late StreamSubscription<DatabaseEvent> chatListen;

  final ScrollController _controller = ScrollController();


  @override
  void initState() {
    super.initState();

    _code = widget.groupCode;
    _chatRef = FirebaseDatabase.instance.ref('chats/$_code');

    WidgetsBinding.instance?.addPostFrameCallback((_) async {

      FirebaseAuth.instance
          .userChanges()
          .listen((User? user) {
        if (user != null) {
          setState(() {
            _messageSenderId = user.uid;
          });
        }
      });

      _sqLiteDb = SqLiteDbHelper();
      await _sqLiteDb.initializer();

      _chats = await _sqLiteDb.chats();

      chatListen = _chatRef.onValue.listen((DatabaseEvent event) async{
        if (event.snapshot.exists){

          Chat chat = Chat.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
          await _sqLiteDb.insertChat(chat);

          _sqLiteDb.chats().then((value)  {
            setState(() {
              _chats = value;
            });

          });

          await _chatRef.set(null);
        }
      });

      setState(() {});

    });

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {

      _sqLiteDb = SqLiteDbHelper();
      await _sqLiteDb.initializer();

      _sqLiteDb.chats().then((value)  {
        setState(() {
          _chats = value;
        });

      });

    });

  }

  @override
  void dispose(){
    super.dispose();
    _sqLiteDb.dbClose();
    chatListen.cancel();
  }

  void _sendMessage (String chatMsg) async{
    Chat chat = Chat.construct(message: chatMsg, senderId: _messageSenderId, groupCode: _code, time: DateTime.now().millisecondsSinceEpoch);
    await _chatRef.update(chat.toMap());
    _editingController.text = "";
  }

  Widget _sendMessageView(){

    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      color: const Color(0xff3D513A),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                    color: const Color(0xff2D4228),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: const Color(0xff2D4228), width: 2.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                          child: Container(
                            height:30,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              controller: _editingController,
                              focusNode: _focusNode,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                height: 1.0,
                              ),
                              decoration: const InputDecoration(
                                hintText: "Enter message",
                                hintStyle: TextStyle(color: Color(0xffA8B0A2)),
                                fillColor: Color(0xff2D4228),
                                filled: true,
                                contentPadding: EdgeInsets.all(12.5),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                      ),
                      const Icon(
                        Icons.emoji_emotions_outlined,
                        size: 30 ,
                        color: Color(0xffA8B0A2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 45,
            width: 45,
            padding: const EdgeInsets.only(left: 2, bottom: 4),
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
            decoration: BoxDecoration(
              color: const Color(0xff2D4228),
              borderRadius: BorderRadius.circular(100.0),
              border: Border.all(color: const Color(0xff2D4228), width: 0.0),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: IconButton(
                icon: const Icon(
                  Icons.send_outlined,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  _sendMessage(_editingController.text);
                },
              ),
            )
          ),
        ],
      ),
    );

  }

  Widget _buildChatWidgets() {
    return ListView.builder(
      controller: _controller,
      itemBuilder: (BuildContext context, int index) {
        var _chat = _chats[index];
        return ChatTile(
          chat: _chat,
          uid: _messageSenderId,
        );
      },
      itemCount: _chats.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(_code),
        elevation: 2,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 50, top: 5),
              color: Colors.black,
              child: _buildChatWidgets(),
            ),
            Positioned(
                bottom: 0,
                child: _sendMessageView(),
            )
          ],
        ),
      ),
    );
  }

}