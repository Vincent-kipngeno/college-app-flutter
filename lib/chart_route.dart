import 'package:flutter/material.dart';

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
  final _chats = <Chat>[];
  late String code;

  final ScrollController _controller = ScrollController();

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState(){
    super.initState();
    code = widget.groupCode;

  }

  void _sendMessage(String value){

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
              color: const Color(0xff2D4228),
              decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: const Color(0xff2D4228), width: 2.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: <Widget>[
                  Flexible(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _editingController,
                        focusNode: _focusNode,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Enter message",
                          hintStyle: TextStyle(color: Color(0xffA8B0A2)),
                          fillColor: Color(0xff2D4228),
                          filled: true,
                          contentPadding: EdgeInsets.all(15),
                        ),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.emoji_emotions_outlined,
                    size: 40 ,
                    color: Color(0xffA8B0A2),
                  ),
                ],
              ),
            )
          ),
          IconButton(
              icon: const ImageIcon(
                AssetImage("assets/images/send_button.png"),
                size: 30,
              ),
              onPressed: () {
                _sendMessage(_editingController.text);
              },
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
        );
      },
      itemCount: _chats.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(code),
        elevation: 2,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
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