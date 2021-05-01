import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_chat_ui_starter/helper/constants.dart';
import 'package:flutter_chat_ui_starter/services/database.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomID;
  final String username;
  
  ChatScreen(this.chatRoomID, this.username);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = TextEditingController();

  Stream conversations;

  final _controller = ScrollController();

  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String, dynamic> messageMap = {
          "message": messageController.text,
          "sentBy": Constants.myName,
          "dateSent": DateFormat.yMMMMd().add_jms().format(DateTime.now()),
          "timeSent": DateFormat.jm().format(DateTime.now()),
          "isLiked": false,
          "isRead": false
      };
    
      databaseMethods.saveMessage(widget.chatRoomID, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversation(widget.chatRoomID).then((value){
      setState(() {
        conversations = value;
      });
    });
    super.initState();
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height:  70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: messageController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),  
            )
          ),
          IconButton(
            icon:  Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              sendMessage();
            },  
          )
        ],
      )
    );
  }

  Widget convos(){
    return StreamBuilder(stream: conversations, builder: (context, snapshot){
      Timer(Duration(seconds: 1),() => _controller.jumpTo(_controller.position.maxScrollExtent));
      return snapshot.hasData ? ListView.builder(
        padding: EdgeInsets.only(top: 15.0),
        controller: _controller,
        itemCount: snapshot.data.size,
        itemBuilder: (context, index){
          bool isMe = snapshot.data.docs[index].data()["sentBy"] == Constants.myName;
          return ConversationTile(snapshot.data.docs[index].data()["message"], snapshot.data.docs[index].data()["timeSent"], snapshot.data.docs[index].data()["isLiked"] ,isMe);
        }) : Container();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title:  Text(
          widget.username,
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: ClipRRect(
                  child: convos(),
                )
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}

class ConversationTile extends StatelessWidget {
    final String message;
    final String timeSent;
    final bool isLiked;
    final bool isMe;
    ConversationTile(this.message, this.timeSent, this.isLiked, this.isMe);

    @override
    Widget build(BuildContext context) {
      final Container msg = Container(
        margin: isMe ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0) : EdgeInsets.only(top: 8.0, bottom: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: BoxDecoration(
          color: isMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
          borderRadius: isMe ? BorderRadius.only(
            topLeft: Radius.circular(15.0),
            bottomLeft: Radius.circular(15.0)
          ) : BorderRadius.only(
            topRight: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0)
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16.0,
                fontWeight: FontWeight.w600
              )
            ),
            SizedBox(height: 8.0), 
            Text(
              timeSent,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16.0,
                fontWeight: FontWeight.w600
              )
            ),
          ]
        )
      );

      if(isMe){
        return msg;
      }

      return Row(
        children: <Widget>[
          msg,
          IconButton(
            icon: isLiked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
            iconSize: 30.0,
            color: isLiked ? Colors.red : Colors.blueGrey,
            onPressed: () {

            },
          )
        ]
      );
    }
  }
