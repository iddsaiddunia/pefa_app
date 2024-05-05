import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfa_app/color_themes.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 241, 241),
      // appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  BotChatBox(),
                  ClientChatBox(),
                  BotChatBox(),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 70.0,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(color: Colors.transparent),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.23,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Message",
                    ),
                  ),
                ),
                Container(
                  width: 55,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.buttonColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: Icon(Icons.send,color: Colors.white,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BotChatBox extends StatelessWidget {
  const BotChatBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
          widthFactor: 0.9,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15),bottomRight:Radius.circular(15), bottomLeft: Radius.circular(2) ),
              ),
              child: Text("hello  world hdbdbvhid hbsijcincncncndncndhbhcbd",style: TextStyle(fontSize:13,),maxLines: 10,softWrap: true,overflow: TextOverflow.ellipsis,),
            ),
          ),
        ),
      ),
    );
  }
}

class ClientChatBox extends StatelessWidget {
  const ClientChatBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: Container(
          padding:
          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(topLeft:Radius.circular(15), topRight: Radius.circular(15),bottomRight:Radius.circular(2), bottomLeft: Radius.circular(15) ),
          ),
          child: Center(
            child: Text("can i get my monthly financial report",style: TextStyle(fontSize:13,color: Colors.white),maxLines: 4,softWrap: true,overflow: TextOverflow.ellipsis,),
          ),
        ),
      ),
    );
  }
}

