import 'package:flutter/material.dart';
import 'package:pfa_app/color_themes.dart';
import 'package:pfa_app/components.dart';
import 'package:pfa_app/models/target_model.dart';
import 'package:pfa_app/services/api_services.dart';
import 'package:pfa_app/services/auth_services.dart';
import 'package:pfa_app/services/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';

AuthService _authService = AuthService();

class TargetsPage extends StatefulWidget {
  const TargetsPage({super.key});

  @override
  State<TargetsPage> createState() => _TargetsPageState();
}

class _TargetsPageState extends State<TargetsPage> {
  final ApiService _apiService = ApiService();

  TextEditingController targetNameController = TextEditingController();
  TextEditingController targetAmountController = TextEditingController();
  TextEditingController targetDescriptionController = TextEditingController();
  DateTime? selectedDate;
  bool isLoading = false;

  late Future<List<Target>> fetchTargets;

  @override
  void initState() {
    super.initState();
    fetchTargets = ApiService.getTargets();
  }

  _saveTarget() async {
    // String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    setState(() {
      isLoading = true;
    });
    if (targetNameController.text != "" &&
        targetAmountController.text != "" &&
        targetDescriptionController.text != "" &&
        selectedDate != null) {
      String? token = await _authService.getToken();
      int? userId;
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getInt('userId');

      // Extract user ID from the token (replace this with your method)
      // int userId = 1;

      String targetName = targetNameController.text;
      String description = targetDescriptionController.text;
      String targetedAmount = targetAmountController.text;

      // print('User ID: $userId');

      Map<String, dynamic> targetData = {
        'user': userId,
        'target_name': targetName,
        'description': description,
        'targeted_amount': targetedAmount,
        'amount_saved': 0.00,
        'target_date': formatDate(selectedDate!)
      };

      var response = await _apiService.createTarget(targetData);

      if (response != null && !response.containsKey('error')) {
        _showDialog('Target Added', 'Your target has been added successfully.');
      } else if (response != null && response.containsKey('error')) {
        _showDialog('Failed to Add Target', response['error'].toString());
      } else {
        _showDialog('Failed to Add Target', 'An unexpected error occurred.');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill all fields')),
      );
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      print('Selected Date: $picked');
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  deleteTarget() {
    showDialog(
        context: context,
        builder: (BuildContext contex) {
          return AlertDialog(
            title: const Text(
              "Alert!",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),
            actions: [
              MaterialButton(
                elevation: 0,
                color: Colors.redAccent,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              MaterialButton(
                  elevation: 0,
                  color: const Color.fromARGB(255, 66, 202, 137),
                  onPressed: () async {
                    // setState(() {
                    //   _isLoading = true;
                    // });
                    // if (_savingAmountController.text != "") {
                    //   double amount =
                    //       double.parse(_savingAmountController.text);
                    //   final prefs = await SharedPreferences.getInstance();
                    //   var userId = prefs.getInt('userId');

                    //   Saving newSaving = Saving(
                    //     id: 0,
                    //     user: userId!,
                    //     amount: amount,
                    //     createdAt: DateTime.now(),
                    //   );

                    //   // Call the createSaving function
                    //   try {
                    //     Saving createdSaving =
                    //         await SavingService.createSaving(newSaving);
                    //     _savingAmountController.clear();
                    //     setState(() {
                    //       _isLoading = false;
                    //     });
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(
                    //           content: Text('Saving added successfully')),
                    //     );
                    //     // print(
                    //     //     'Created Saving: ${createdSaving.id}, Amount: ${createdSaving.amount}');
                    //   } catch (e) {
                    //     setState(() {
                    //       _isLoading = false;
                    //     });
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(
                    //           content: Text('Error while adding service')),
                    //     );
                    //     // print('Error creating saving: $e');
                    //   }
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text('Fill amount'),
                    //     ),
                    //   );
                    // }
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  )),
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Are you sure you want to delete this target"),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    // Get the user details
    // int? userId = userProvider.userId;
    // print(">>>>>>>>>>>>>>>>$userId");
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
              const TabBar(
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            height: 55,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black26),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: TextField(
                              controller: targetNameController,
                              decoration: const InputDecoration(
                                  hintText: "Enter target",
                                  hintStyle: TextStyle(fontSize: 14),
                                  border: InputBorder.none),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 55,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black26),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: targetAmountController,
                              decoration: const InputDecoration(
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              width: 150,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: const Row(
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
                          Text(
                            (selectedDate == null)
                                ? "No date selected"
                                : formatDate(selectedDate!),
                          ),
                          Container(
                            width: double.infinity,
                            height: 55,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black26),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: TextField(
                              controller: targetDescriptionController,
                              decoration: const InputDecoration(
                                  hintText: "Enter target description",
                                  hintStyle: TextStyle(fontSize: 14),
                                  border: InputBorder.none),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          MaterialButton(
                            height: 55.0,
                            minWidth: double.infinity,
                            textColor: Colors.white,
                            color: color.buttonColor,
                            onPressed: () {
                              // addTarget(targetNameController.text, targetAmountController.text, targetDescriptionController.text);
                              _saveTarget();
                            },
                            child: (!isLoading)
                                ? const Text("Add target")
                                : const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 55,
                          ),
                          Expanded(
                            child: FutureBuilder<List<Target>>(
                              future: fetchTargets,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  // print(snapshot.data!.length);
                                  return ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (contaxt, index) {
                                      double percentage = (snapshot
                                              .data![index].amountSaved /
                                          snapshot.data![index].targetedAmount);
                                      DateTime currentTimestamp =
                                          DateTime.now(); // Example timestamp 1
                                      DateTime targetTime = snapshot
                                          .data![index]
                                          .targetDate; // Example timestamp 2

                                      // Calculate the difference in days
                                      int targetRemainingDays = targetTime
                                          .difference(currentTimestamp)
                                          .inDays;

                                      return MyTarget(
                                        name: snapshot.data![index].targetName,
                                        description:
                                            snapshot.data![index].description,
                                        progress:
                                            snapshot.data![index].targetStatus,
                                        targetAMount: snapshot
                                            .data![index].targetedAmount,
                                        savedAMount:
                                            snapshot.data![index].amountSaved,
                                        remainingDays: targetRemainingDays,
                                        ontapDelete: () {
                                          deleteTarget();
                                        },
                                      );
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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

  void _showDialog(String title, String content) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if (title == 'Target Added') {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class MyTarget extends StatelessWidget {
  final String name;
  final String description;
  final String progress;
  final double targetAMount;
  final double savedAMount;
  final int remainingDays;
  final Function()? ontapDelete;
  const MyTarget({
    super.key,
    required this.name,
    required this.description,
    required this.progress,
    required this.targetAMount,
    required this.savedAMount,
    required this.remainingDays,
    required this.ontapDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.black12,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Text(
                  progress,
                  style: TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              VerticalTextTIle(
                  title: "Target Amount", content: targetAMount.toString()),
              VerticalTextTIle(
                  title: "Saved Amount", content: savedAMount.toString()),
              VerticalTextTIle(
                  title: "Remaining Days", content: remainingDays.toString()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                minWidth: 120,
                elevation: 0,
                color: Colors.blue,
                onPressed: () {},
                child: Text(
                  "Update",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              MaterialButton(
                minWidth: 120,
                elevation: 0,
                color: Color.fromARGB(255, 116, 116, 116),
                onPressed: ontapDelete,
                child: Text(
                  "Delete",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
