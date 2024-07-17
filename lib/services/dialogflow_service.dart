import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dialogflow_flutter/dialogflowFlutter.dart';
import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:dialogflow_flutter/language.dart';

// class DialogflowService {
//   final AuthGoogle authGoogle;
//   final DialogFlow dialogflow;

//   DialogflowService(this.authGoogle, this.dialogflow);

//   static Future<DialogflowService> init() async {
//     AuthGoogle authGoogle =
//         await AuthGoogle(fileJson: "assets/pefa-426502-2ed1b6087ad0.json")
//             .build();
//     DialogFlow dialogflow =
//         DialogFlow(authGoogle: authGoogle, language: Language.english);
//     return DialogflowService(authGoogle, dialogflow);
//   }

//   Future<AIResponse> sendQuery(String query) async {
//     AIResponse response = await dialogflow.detectIntent(query);
//     // print("----------->>>>${response.queryResult!.intent!.displayName}");
//     return response;
//   }
// }

// import 'package:dialogflow_v2/dialogflow_v2.dart';

class DialogflowService {
  final AuthGoogle authGoogle;
  final DialogFlow dialogflow;

  DialogflowService(this.authGoogle, this.dialogflow);

  static Future<DialogflowService> init() async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/pefa-426502-2ed1b6087ad0.json")
            .build();
    DialogFlow dialogflow =
        DialogFlow(authGoogle: authGoogle, language: Language.english);
    return DialogflowService(authGoogle, dialogflow);
  }

  Future<AIResponse> sendQuery(String query) async {
    AIResponse response = await dialogflow.detectIntent(query);
    print("Fulfillment Text: ${response.queryResult!.fulfillmentText}");
    print(
        "Intent Display Name: ${response.queryResult!.parameters!['ServiceType']}");

    return response;
  }
}
