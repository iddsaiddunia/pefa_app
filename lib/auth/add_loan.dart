import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pfa_app/auth/base_layout.dart';
import 'package:pfa_app/auth/home.dart';
import 'package:pfa_app/color_themes.dart';
import 'package:pfa_app/components.dart';
import 'package:pfa_app/models/loan_model.dart';
import 'package:pfa_app/services/auth_services.dart';
import 'package:pfa_app/services/loan_service.dart';

AuthService _authService = AuthService();
LoanService _loanService = LoanService();

class LoansPage extends StatefulWidget {
  const LoansPage({super.key});

  @override
  State<LoansPage> createState() => _LoansPageState();
}

class _LoansPageState extends State<LoansPage> {
  final TextEditingController _actorController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  String dropdownvalue = 'own';
  DateTime? selectedDate;
  bool isLoading = false;
  late Future<List<Loan>> fetchLoans;

  // List of items in our dropdown menu
  var items = [
    'own',
    'owned',
  ];

  @override
  void initState() {
    super.initState();
    fetchLoans = LoanService.getLoans();
  }

  String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  _addLoan() async {
    setState(() {
      isLoading = true;
    });
    if (_actorController.text != "" ||
        _amountController.text != "" ||
        _descriptionController.text != "") {
      String? token = await _authService.getToken();

      // Extract user ID from the token (replace this with your method)
      int userId = 1;

      double amount = double.parse(_amountController.text);
      double? interest = double.parse(_interestController.text);
      String actor = _actorController.text;
      String description = _descriptionController.text;

      Map<String, dynamic> loanData = {
        'user': userId,
        'loan_type': dropdownvalue,
        'actor_name': actor,
        'amount': amount,
        'amountPayed': 0.0,
        'interest': interest ?? 0.0,
        'loan_due_date': formatDate(selectedDate!),
        'description': description,
      };

      var response = await _loanService.createLoan(token!, loanData);
      if (response != null && !response.containsKey('error')) {
        _showDialog('Loan Added', 'Your loan has been added successfully.');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BaseLayout(),
          ),
        );
      } else if (response != null && response.containsKey('error')) {
        _showDialog('Failed to Add Loan', response['error'].toString());
      } else {
        _showDialog('Failed to Add Loan', 'An unexpected error occurred.');
      }

      setState(() {
        isLoading = false;
      });
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
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _deleteLoan(int id, int index, List<Loan> loans) async {
    try {
      await _loanService.deleteLoan(id);
      setState(() {
        loans.removeAt(index);
        fetchLoans = LoanService.getLoans();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loan deleted')),
      );
    } catch (e) {
      setState(() {
        fetchLoans = LoanService.getLoans();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete loan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
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
                    text: "New Loan",
                  ),
                  Tab(text: "My Loans"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Container(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          InputBox(
                            isText: true,
                            title: "Credit/Debited to",
                            controller: _actorController,
                          ),
                          InputBox(
                            isText: false,
                            title: "Amount",
                            controller: _amountController,
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
                            child: DropdownButton(
                              isExpanded: true,
                              elevation: 0,
                              // Initial Value
                              value: dropdownvalue,
                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                });
                              },
                            ),
                          ),
                          InputBox(
                            isText: false,
                            title: "Interest(0%)",
                            controller: _interestController,
                          ),
                          SizedBox(
                            height: 5,
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      "Due date",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
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
                          SizedBox(
                            height: 20,
                          ),
                          InputBox(
                            isText: true,
                            title: "Description",
                            controller: _descriptionController,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                            color: color.buttonColor,
                            minWidth: double.infinity,
                            height: 55,
                            onPressed: () {
                              _addLoan();
                            },
                            child: (!isLoading)
                                ? Text(
                                    "Add Loan",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : CircularProgressIndicator(
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
                            child: FutureBuilder<List<Loan>>(
                              future: fetchLoans,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text("${snapshot.error}"));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                      child: const Text('No loans available'));
                                } else {
                                  return ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      final loan = snapshot.data![index];
                                      double? interestAmount =
                                          loan.interest! * (loan.amount / 100);

                                      int remainingDays = loan.loanDueDate
                                          .difference(DateTime.now())
                                          .inDays;

                                      return Dismissible(
                                        key: Key(loan.id.toString()),
                                        direction: DismissDirection.endToStart,
                                        onDismissed: (direction) {
                                          print(loan.id);
                                          _deleteLoan(
                                              loan.id, index, snapshot.data!);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Loan ${loan.loanType} dismissed'),
                                            ),
                                          );
                                        },
                                        background: Container(
                                          color: Colors.red,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          alignment:
                                              AlignmentDirectional.centerEnd,
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: LoanCard(
                                          loanType: loan.loanType,
                                          actorName: loan.actorName,
                                          amount: loan.amount,
                                          amountPayed: loan.amountPayed,
                                          remainingDays: remainingDays,
                                          interestAmount: interestAmount,
                                        ),
                                      );
                                    },
                                  );
                                }
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

class LoanCard extends StatelessWidget {
  final String loanType;
  final String actorName;
  final double amount;
  final double amountPayed;
  final int remainingDays;
  final double interestAmount;
  const LoanCard({
    super.key,
    required this.loanType,
    required this.actorName,
    required this.amount,
    required this.amountPayed,
    required this.remainingDays,
    required this.interestAmount,
  });

  @override
  Widget build(BuildContext context) {
    double remainingAmount = (amount + interestAmount) - amountPayed;
    return Container(
      width: double.infinity,
      height: 110,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: Colors.black12,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 241, 241, 241),
            blurRadius: 1.5,
            spreadRadius: 1.5,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  (loanType == "own")
                      ? const Text(
                          "To-",
                          style: TextStyle(fontSize: 13),
                        )
                      : const Text(
                          "From-",
                          style: TextStyle(fontSize: 13),
                        ),
                  Text(
                    actorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "Remaining: ",
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    "${remainingAmount.toString()} Tsh",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Interest",
                        style: TextStyle(fontSize: 13),
                      ),
                      Text(
                        "${interestAmount.toString()} Tsh",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Payed",
                        style: TextStyle(fontSize: 13),
                      ),
                      Text(
                        "${amountPayed.toString()} Tsh",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    width: 70,
                    height: 35,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "remaining",
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${remainingDays.toString()} days",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
