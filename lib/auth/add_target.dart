import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pfa_app/color_themes.dart';
import 'package:pfa_app/models/target_model.dart';

class TargetsPage extends StatefulWidget {
  const TargetsPage({super.key});

  @override
  State<TargetsPage> createState() => _TargetsPageState();
}

class _TargetsPageState extends State<TargetsPage> {
  TextEditingController targetNameController = new TextEditingController();
  TextEditingController targetAmountController = new TextEditingController();
  TextEditingController targetDescriptionController =
      new TextEditingController();
  DateTime selectedDate =DateTime.now();
  bool isLoading = false;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> addTarget(
      String targetName, String targetAmount, String targetDescription) async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2));
    if (targetName != "" &&
        targetAmount != "" &&
        targetDescription != "" &&
        selectedDate != "") {
      myTargets.add(
        Target(
            targetName: targetName,
            targetAmount: double.parse(targetAmount),
            targetDuration: selectedDate,
            targetDescription: targetDescription,
            currentAmount: 0,
            status: TargetStatus.onprogress),
      );
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('target is added sucessifuly'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
      );
    }else{
      print("fill all data inputs");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                padding: EdgeInsets.all(0),
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                labelPadding: EdgeInsets.all(0),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14,
                  // fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
                labelStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                tabs: [
                  Tab(
                    text: "New Target",
                  ),
                  Tab(text: "My Targets"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            height: 55,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black26),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: TextField(
                              controller: targetNameController,
                              decoration: InputDecoration(
                                  hintText: "Enter target",
                                  hintStyle: TextStyle(fontSize: 14),
                                  border: InputBorder.none),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 55,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black26),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: targetAmountController,
                              decoration: InputDecoration(
                                  hintText: "Enter target amount",
                                  hintStyle: TextStyle(fontSize: 14),
                                  border: InputBorder.none),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.calendar_month),
                                  Text(
                                    "Target date",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(selectedDate.toString()),
                          Container(
                            width: double.infinity,
                            height: 55,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black26),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: TextField(
                              controller: targetDescriptionController,
                              decoration: InputDecoration(
                                  hintText: "Enter target description",
                                  hintStyle: TextStyle(fontSize: 14),
                                  border: InputBorder.none),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          MaterialButton(
                            height: 55.0,
                            minWidth: double.infinity,
                            textColor: Colors.white,
                            color: color.buttonColor,
                            onPressed: () {
                              addTarget(targetNameController.text, targetAmountController.text, targetDescriptionController.text);
                            },
                            child: (!isLoading)
                                ? Text("Add target")
                                : CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Text("hello world2"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
