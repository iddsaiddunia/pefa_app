import 'dart:convert';

import 'package:dialogflow_flutter/dialogflowFlutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:pfa_app/color_themes.dart';
import 'package:pfa_app/services/auth_services.dart';
import 'package:pfa_app/services/dialogflow_service.dart';

// pefa-bot@pefa-426502.iam.gserviceaccount.com

AuthService _authService = AuthService();

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final List<ChatMessage> _messages = [
    // ChatMessage(text: "hell", name: "Bot", type: false),
  ];
  late DialogflowService _dialogflowService;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _showGreeting();
    initDialogflow();
  }

  void initDialogflow() async {
    _dialogflowService = await DialogflowService.init();
  }

  void _showGreeting() {
    ChatMessage message = ChatMessage(
      text:
          "Hello! I'm your finance assistant. How can I help you today? You can ask me about your budgets, goals/targets, loans, transactions and predictions on your expensies hope to here back from you.",
      name: "Bot",
      type: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) async {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      name: "User",
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });

    AIResponse response = await _dialogflowService.sendQuery(text);

    String fulfillmentText = response.getMessage() ?? "";
    ChatMessage botMessage = ChatMessage(
      text: fulfillmentText,
      name: "Bot",
      type: false,
    );

    setState(() {
      _messages.insert(0, botMessage);
    });

    _sendToBackend(response);
  }

  void _sendToBackend(AIResponse response) async {
    // String email = response.queryResult!.parameters!['email'];
    String? serviceType = response.queryResult!.parameters!['ServiceType'];

    var url = Uri.parse('https://pefa-432220d0c209.herokuapp.com/bot/webhook/');
    String? token = await _authService.getToken();

    try {
      var responseBackend = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "queryResult": {
            "queryText": response.queryResult!.queryText,
            "parameters": {"ServiceType": serviceType},
            "intent": {"displayName": serviceType}
          }
        }),
      );

      if (responseBackend.statusCode == 200) {
        var jsonResponse = json.decode(responseBackend.body);
        ChatMessage backendMessage = ChatMessage(
          text: jsonResponse['fulfillmentText'],
          name: "Bot",
          type: false,
        );
        setState(() {
          _messages.insert(0, backendMessage);
        });
      } else {
        ChatMessage errorMessage = ChatMessage(
          text:
              "Sorry i am having trouble fetching data please try again in a while thank!",
          name: "Bot",
          type: false,
        );
        setState(() {
          _messages.insert(0, errorMessage);
        });
      }
    } catch (e) {
      print("Error sending request: $e");
      // Handle error as needed
    }
  }

  // void _handleSubmitted(String text) {
  //   _textController.clear();
  //   ChatMessage message = ChatMessage(
  //     text: text,
  //     name: "User",
  //     type: true,
  //   );
  //   setState(() {
  //     _messages.insert(0, message);
  //   });
  //   _handleQuery(text);
  // }

  void _handleQuery(String query) async {
    await Future.delayed(const Duration(seconds: 2));
    String? responseText;
    if (query.toLowerCase().contains('hello') ||
        query.toLowerCase().contains('hi')) {
      responseText = "Hi there! How can I assist you with your finances today?";
    }
    //else if (query.toLowerCase().contains('budget')) {
    //   List<Budget> budgets = await apiService.fetchBudgets();
    //   responseText = budgets.isNotEmpty
    //       ? budgets.map((b) => '${b.name}: \$${b.amount}').join('\n')
    //       : "You have no budgets set up yet.";
    // } else if (query.toLowerCase().contains('goal')) {
    //   List<Goal> goals = await apiService.fetchGoals();
    //   responseText = goals.isNotEmpty
    //       ? goals.map((g) => '${g.name}: \$${g.currentAmount} of \$${g.targetAmount}').join('\n')
    //       : "You have no goals set up yet.";
    // }
    else {
      responseText =
          "Sorry, I did not understand that. Please ask about budgets or goals.";
    }
    _showResponse(responseText);
  }

  void _showResponse(String responseText) {
    ChatMessage message = ChatMessage(
      text: responseText,
      name: "Bot",
      type: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

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
                child: ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return (_messages[index].name == "Bot")
                          ? BotChatBox(
                              text: _messages[index].text,
                            )
                          : ClientChatBox(text: _messages[index].text);
                    })),
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
                    controller: _textController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Message",
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_textController.text != "") {
                      _handleSubmitted(_textController.text);
                    }
                  },
                  child: Container(
                    width: 55,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color.buttonColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
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

class ChatMessage {
  ChatMessage({required this.text, required this.name, required this.type});

  final String text;
  final String name;
  final bool type;
}

class BotChatBox extends StatelessWidget {
  final String text;
  const BotChatBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(2)),
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                ),
                maxLines: 10,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ClientChatBox extends StatelessWidget {
  final String text;
  const ClientChatBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(2),
                bottomLeft: Radius.circular(15)),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.white),
              maxLines: 4,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
