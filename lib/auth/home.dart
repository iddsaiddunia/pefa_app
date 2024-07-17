import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pfa_app/auth/add_loan.dart';
import 'package:pfa_app/auth/add_target.dart';
import 'package:pfa_app/color_themes.dart';
import 'package:pfa_app/models/budget_model.dart';
import 'package:pfa_app/models/loan_model.dart';
import 'package:pfa_app/models/saving_model.dart';
import 'package:pfa_app/models/transaction_model.dart';
import 'package:pfa_app/services/api_services.dart';
import 'package:pfa_app/services/auth_services.dart';
import 'package:pfa_app/services/budget_service.dart';
import 'package:pfa_app/services/loan_service.dart';
import 'package:pfa_app/services/saving_services.dart';
import 'package:pfa_app/services/transaction_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../components.dart';
import '../models/target_model.dart';

TransactionService _transactionService = TransactionService();
SavingService _savingService = SavingService();
ApiService _apiService = ApiService();
AuthService _authService = AuthService();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  final PageController _loanTypeController = PageController(initialPage: 0);
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _savingAmountController = TextEditingController();
  final TextEditingController _targetSavedAmountController =
      TextEditingController();
  int _selectedIndex = 0;
  int _selectedLoanType = 0;
  String dropdownvalue = 'Cash';
  String purposedropdownvalue = 'bills';
  String transactionTypevalue = 'expense';
  String? _selectedOption = "other sources";
  int? userId;
  double _totalSavedAmount = 0.0;
  double totalBalance = 0.0;
  bool _isConnected = false;

  bool isInsightOpen = true;
  bool addTransaction = false;
  bool isTransLoading = false;
  bool _isLoading = false;
  bool _loadSaving = false;
  bool isViewAll = false;
  List<Target> targetList = [];
  List<Loan> loanList = [];

  Target? selectedTarget;
  Loan? selectedLoan;

  late Future<List<Target>> fetchTargets;
  late Future<List<Loan>> fetchLoans;
  late Future<List<Saving>> fetchSavings;
  late Future<List<Transaction>> fetchTransactions;
  late Future<List<Budget>> futureBudgets;
  late Future<Map<String, dynamic>> _totalsFuture;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    InternetConnectionChecker().onStatusChange.listen((status) {
      setState(() {
        _isConnected = status == InternetConnectionStatus.connected;
      });
    });
    _loadUserId();
    fetchTargets = ApiService.getTargets();
    _apiService.checkAndUpdateTargetsStatus();
    fetchLoans = LoanService.getLoans();
    fetchSavings = SavingService.getSavings();
    fetchTransactions = _transactionService.getTransactions();
    _totalsFuture = _transactionService.getTotalIncomeExpenses();
    futureBudgets = BudgetService.fetchBudgets();
    _loadTotalSavingAmount();
    fetchTargets.then((target) => {
          setState(() {
            targetList = target;
          })
        });

    fetchLoans.then((loan) => {
          setState(() {
            loanList = loan;
          })
        });
  }

  // List of items in our dropdown menu
  var items = [
    'Cash',
    'Mobile Transaction',
    'Bank Transaction',
  ];
  var transactionType = [
    'expense',
    'income',
  ];
  var purposeItems = [
    "bills",
    "food and groceries",
    "transportation",
    "healthcare",
    "personal Care",
    "loan",
    "saving",
    "target",
    "miscellaneous"
  ];

  List<String> tabsLength = ["All", "Income", "Expense"];

  Future<void> checkConnectivity() async {
    _isConnected = await InternetConnectionChecker().hasConnection;
    setState(() {});
    if (!_isConnected) {
      _authService.logout(context);
    }
  }

  Future<void> _refreshData() async {
    await Future.wait([
      ApiService.getTargets(),
      LoanService.getLoans(),
      SavingService.getSavings(),
      _transactionService.getTransactions(),
      _transactionService.getTotalIncomeExpenses(),
      BudgetService.fetchBudgets(),
      _loadTotalSavingAmount(), // Ensure this is a Future
    ]);

    setState(() {
      // Re-fetch the data and set the new state
      fetchTargets = ApiService.getTargets();
      fetchLoans = LoanService.getLoans();
      fetchSavings = SavingService.getSavings();
      fetchTransactions = _transactionService.getTransactions();
      _totalsFuture = _transactionService.getTotalIncomeExpenses();
      futureBudgets = BudgetService.fetchBudgets();
    });
  }

  void changeTabs(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void changeLoanType(int index) {
    setState(() {
      _selectedLoanType = index;
    });
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MMM d');
    return formatter.format(dateTime);
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
  }

  Future<void> _loadTotalSavingAmount() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      var userId = prefs.getInt('userId');
      double totalAmount = await SavingService.getTotalAmountForUser(userId!);
      setState(() {
        _totalSavedAmount = totalAmount;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  addSavingsWindow() async {
    setState(() {
      _isLoading = true;
    });
    showDialog(
        context: context,
        builder: (BuildContext contex) {
          return AlertDialog(
            title: const Text(
              "Add Saving",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),
            actions: [
              MaterialButton(
                elevation: 0,
                color: Colors.redAccent,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              MaterialButton(
                  elevation: 0,
                  color: const Color.fromARGB(255, 66, 202, 137),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    if (_savingAmountController.text != "") {
                      double amount =
                          double.parse(_savingAmountController.text);
                      final prefs = await SharedPreferences.getInstance();
                      var userId = prefs.getInt('userId');
                      // print("$userId----->");

                      Saving newSaving = Saving(
                        id: 0,
                        user: userId!,
                        amount: amount,
                        createdAt: DateTime.now(),
                      );

                      // Call the createSaving function
                      try {
                        Navigator.pop(context);
                        loaderWindow();
                        Saving createdSaving =
                            await SavingService.createSaving(newSaving);
                        _savingAmountController.clear();

                        setState(() {
                          _isLoading = false;
                        });

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Saving added successfully')),
                        );
                        // print(
                        //     'Created Saving: ${createdSaving.id}, Amount: ${createdSaving.amount}');
                      } catch (e) {
                        setState(() {
                          _isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed adding service $e')),
                        );
                        print('Error creating saving: $e');
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fill amount'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Add",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  )),
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputBox(
                  isText: false,
                  title: "enter amount",
                  controller: _savingAmountController,
                )
              ],
            ),
          );
        });
  }

  addBudget() async {
    setState(() {
      _isLoading = true;
    });
    List<Budget> existingBudgets = await BudgetService.fetchBudgets();
    Set<String> existingCategories =
        existingBudgets.map((b) => b.category).toSet();

    List<String> availableCategories = purposeItems
        .where((category) => !existingCategories.contains(category))
        .toList();

    final prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('userId');

    String? selectedCategory;
    double? amount;
    int? duration;
    showDialog(
        context: context,
        builder: (BuildContext contex) {
          return AlertDialog(
            title: const Text(
              "Add Budget",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),
            actions: [
              MaterialButton(
                elevation: 0,
                color: Colors.redAccent,
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              MaterialButton(
                  elevation: 0,
                  color: const Color.fromARGB(255, 66, 202, 137),
                  onPressed: () async {
                    if (selectedCategory != null &&
                        amount != null &&
                        duration != null) {
                      Budget newBudget = Budget(
                        userId: userId!,
                        category: selectedCategory!,
                        amount: amount!,
                        duration: duration!,
                        amountUsed: 0.0,
                        createdAt: DateTime.now(),
                      );
                      Navigator.pop(context);
                      loaderWindow();
                      BudgetService.createBudget(newBudget).then((_) {
                        setState(() {
                          futureBudgets = BudgetService.fetchBudgets();
                        });
                        Navigator.of(context).pop();
                        setState(() {
                          _isLoading = false;
                        });
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fill all fields'),
                        ),
                      );
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: const Text(
                    "Add",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  )),
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: availableCategories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedCategory = newValue;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {
                    amount = double.tryParse(value);
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Duration'),
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {
                    duration = int.tryParse(value);
                  },
                ),
              ],
            ),
          );
        });
  }

  viewBudget(String category) async {
    showDialog(
        context: context,
        builder: (BuildContext contex) {
          return AlertDialog(
            title: Text(
              "$category",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            actions: [
              MaterialButton(
                elevation: 0,
                color: color.updateButtonColor,
                onPressed: () {},
                child: const Text(
                  "Update",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              MaterialButton(
                elevation: 0,
                color: color.cancelButtonColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [],
            ),
          );
        });
  }

  addLoanWindow() {
    showDialog(
        context: context,
        builder: (BuildContext contex) {
          return AlertDialog(
            title: const Text(
              "Add new Loan",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),
            actions: [
              MaterialButton(
                elevation: 0,
                color: CupertinoColors.activeGreen,
                onPressed: () {},
                child: const Text("Add Loan"),
              ),
              MaterialButton(
                elevation: 0,
                color: Colors.redAccent,
                onPressed: () {},
                child: const Text("Cancel"),
              ),
            ],
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [],
            ),
          );
        });
  }

  loaderWindow() {
    showDialog(
        context: context,
        builder: (BuildContext contex) {
          return AlertDialog(
              content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ));
        });
  }

  closeInsightBox() {
    setState(() {
      isInsightOpen = !isInsightOpen;
    });
  }

  toggleTransactionCard() {
    setState(() {
      addTransaction = !addTransaction;
    });
    // print(addTransaction);
  }

  showMoreTargetDetails(
    int id,
    String target_name,
    String description,
    String target_status,
    DateTime target_date,
    double targeted_amount,
    double amount_saved,
    canItBeAccomplished,
  ) {
    int differenceInDays = target_date.difference(DateTime.now()).inDays;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            target_name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  VerticalTextTIle(
                    title: "Target Amount",
                    content: targeted_amount.toString(),
                  ),
                  VerticalTextTIle(
                    title: "Target Saved",
                    content: amount_saved.toString(),
                  )
                ],
              ),
              const Divider(),
              VerticalTextTIle(
                title: "Remaining Days",
                content: "${differenceInDays.toString()} days",
              ),
              const Divider(),
              Text(
                description,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(
                height: 5,
              ),
              // InputBox(
              //     title: "new amount saved ($amount_saved)",
              //     controller: _targetSavedAmountController,
              //     isText: false),

              Row(children: [
                Icon(Icons.info),
                (canItBeAccomplished)
                    ? Text("Target can be accomplished")
                    : Text("Hard to accomplish")
              ]),
            ],
          ),
          actions: [
            // MaterialButton(
            //   elevation: 0,
            //   color: color.updateButtonColor,
            //   onPressed: () async {
            //     if (_targetSavedAmountController.text != "") {
            //       Target target = await ApiService.getTargetById(id);

            //       // Update the amountSaved attribute
            //       double newAmountSaved =
            //           double.parse(_targetSavedAmountController.text);
            //       target.amountSaved = newAmountSaved;

            //       // print(target.targetDate);

            //       // Call the updateTarget function
            //       // try {
            //       //   Target updatedTarget =
            //       //       await ApiService.updateTarget(id, target);
            //       //   print(
            //       //       'Updated Target: ${updatedTarget.id}, Amount Saved: ${updatedTarget.amountSaved}');
            //       // } catch (e) {
            //       //   print('Error updating target: $e');
            //       // }
            //     } else {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(
            //           content: Text('Fill amount'),
            //         ),
            //       );
            //     }
            //   },
            //   child: const Text(
            //     "Update",
            //     style: TextStyle(
            //         fontSize: 12,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.white),
            //   ),
            // ),
            MaterialButton(
              elevation: 0,
              color: color.cancelButtonColor,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  addTransactionFn() async {
    setState(() {
      isTransLoading = true;
    });

    if (_amountController.text != "" || _descriptionController.text != "") {
      double amount = double.parse(_amountController.text);
      String description = _descriptionController.text;

      String category = "";
      Map<String, dynamic>? transaction;

      if (transactionTypevalue == "expense") {
        category = purposedropdownvalue;
      } else if (transactionTypevalue == "income") {
        category = _selectedOption!;
      }

      if (category == "target") {
        transaction = {
          "user": userId,
          "amount": amount,
          "transaction_type": transactionTypevalue,
          "category": category,
          "target": selectedTarget!.id,
          "loan": null,
          "description": description,
        };
      } else if (category == "loan") {
        transaction = {
          "user": userId,
          "amount": amount,
          "transaction_type": transactionTypevalue,
          "category": category,
          "target": null,
          "loan": selectedLoan!.id,
          "description": description,
        };
      } else {
        transaction = {
          "user": userId,
          "amount": amount,
          "transaction_type": transactionTypevalue,
          "category": category,
          "target": null,
          "loan": null,
          "description": description,
        };
      }

      var response = await _transactionService.createTransaction(transaction!);

      if (response != null && !response.containsKey('error')) {
        setState(() {
          isTransLoading = false;
        });
        _amountController.clear;
        _refreshData();
        _showDialog('Transaction Added',
            'Your transaction has been added successfully.');
      } else if (response != null && response.containsKey('error')) {
        setState(() {
          isTransLoading = false;
        });
        _showDialog('Failed to Add Transaction', response['error'].toString());
      } else {
        setState(() {
          isTransLoading = false;
        });
        _showDialog(
            'Failed to Add Transaction', 'An unexpected error occurred.');
      }
    } else {
      setState(() {
        isTransLoading = false;
      });
    }
  }

  String formatAmount(double amount) {
    const suffixes = ["", "K", "M", "B", "T"]; // Add more suffixes as needed

    int suffixIndex = 0;
    while (amount >= 1000 && suffixIndex < suffixes.length - 1) {
      suffixIndex++;
      amount /= 1000;
    }

    // Round to one decimal place
    String result = amount.toStringAsFixed(1).replaceAll(RegExp(r'\.0'), '');

    return '$result${suffixes[suffixIndex]}';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        // drawer:Drawer(),
        backgroundColor: const Color.fromARGB(50, 241, 241, 230),

        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: Stack(
            children: [
              ListView(
                children: [
                  (isInsightOpen)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5),
                          child: Container(
                            width: double.infinity,
                            height: 170,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: color.primaryColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 5.0),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15.0),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Insights",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        closeInsightBox();
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7.0, vertical: 5.0),
                                  // height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: FutureBuilder<Map<String, dynamic>>(
                                    future: _totalsFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.white),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text('${snapshot.error}'));
                                      } else if (!snapshot.hasData ||
                                          snapshot.data == null) {
                                        return Center(
                                          child: Text('No data available'),
                                        );
                                      }

                                      final totals = snapshot.data!;

                                      // print("---->>>>>>$totals");
                                      totalBalance = totals['remaining_balance']
                                          .toDouble();

                                      String income = formatAmount(
                                          totals['total_income'].toDouble());
                                      String expenses = formatAmount(
                                          totals['total_expenses'].toDouble());
                                      String balance = formatAmount(
                                          totals['remaining_balance']
                                              .toDouble());

                                      return Column(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  const Text(
                                                    "Income",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    width: 150,
                                                    height: 35,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(5),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .arrow_downward,
                                                              size: 18,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_downward,
                                                              size: 18,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          '$income Tsh',
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    102,
                                                                    102,
                                                                    102),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Text(
                                                    "Expensies",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    width: 150,
                                                    height: 35,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(5),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .arrow_upward,
                                                              size: 18,
                                                              color: Colors.red,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_upward,
                                                              size: 18,
                                                              color: Colors.red,
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          "$expenses Tsh",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    102,
                                                                    102,
                                                                    102),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                          Row(
                                            children: [
                                              Text(
                                                "Total Balance",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 235, 211, 211),
                                                ),
                                              ),
                                              SizedBox(width: 30),
                                              Text(
                                                "$balance Tsh",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Color.fromARGB(
                                                      255, 250, 250, 250),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 180,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "My Targets",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              CustomeIconButton(
                                  title: "Add Target",
                                  ontap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const TargetsPage(),
                                      ),
                                    );
                                  },
                                  icon: Icons.add)
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: FutureBuilder<List<Target>>(
                              future: fetchTargets,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.blue,
                                  ));
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                    child: const Text(
                                        'No targets available, start now ):'),
                                  );
                                } else {
                                  // List<Target> targets = snapshot.data!;
                                  return ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (contaxt, index) {
                                      double remainingAmount =
                                          snapshot.data![index].targetedAmount -
                                              snapshot.data![index].amountSaved;
                                      bool canItBeAccomplished = false;
                                      if (totalBalance >= remainingAmount) {
                                        canItBeAccomplished = true;
                                      } else {
                                        canItBeAccomplished = false;
                                      }

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

                                      return (snapshot
                                                  .data![index].targetStatus ==
                                              "onprogress")
                                          ? TargetCard(
                                              targetName: snapshot
                                                  .data![index].targetName,
                                              targetAmount: snapshot
                                                  .data![index].targetedAmount,
                                              percent: percentage,
                                              timeRemained: targetRemainingDays
                                                  .toString(),
                                              ontap: () {
                                                showMoreTargetDetails(
                                                    snapshot.data![index].id,
                                                    snapshot.data![index]
                                                        .targetName,
                                                    snapshot.data![index]
                                                        .description,
                                                    snapshot.data![index]
                                                        .targetStatus,
                                                    snapshot.data![index]
                                                        .targetDate,
                                                    snapshot.data![index]
                                                        .targetedAmount,
                                                    snapshot.data![index]
                                                        .amountSaved,
                                                    canItBeAccomplished);
                                              },
                                              canItBeAccomplished:
                                                  canItBeAccomplished)
                                          : Center();
                                    },
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                      // height: 10.0,
                      ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: double.infinity,
                      height: 350,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        border: Border.all(width: 1, color: Colors.black12),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 95,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                border:
                                    Border.all(width: 1, color: Colors.blue),
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 48,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Savings",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          addSavingsWindow();
                                        },
                                        child: const Icon(
                                          Icons.add,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 43,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8),
                                    ),
                                  ),
                                  child: Center(
                                    child: (_isLoading)
                                        ? Text("....")
                                        : Text(
                                            "${_totalSavedAmount.toString()} Tsh",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 40,
                                child: const Text(
                                  "My Budgets",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 120,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(10),
                                  ),
                                  border: Border.all(
                                      width: 1, color: Colors.black12),
                                ),
                                child: FutureBuilder<List<Budget>>(
                                  future: futureBudgets,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.blue,
                                      ));
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Center(
                                        child: const Text(
                                            'No budgets available, start now.'),
                                      );
                                    } else {
                                      List<Budget> budgets = snapshot.data!;
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: budgets.length,
                                        itemBuilder: (context, index) {
                                          Budget budget = budgets[index];
                                          String formatedAmount =
                                              formatAmount(budget.amount);
                                          String usedformatedAmount =
                                              formatAmount(budget.amountUsed);
                                          double percentage =
                                              (budget.amountUsed /
                                                      budget.amount) *
                                                  100;
                                          // DateTime currentTimestamp = DateTime
                                          //     .now(); // Example timestamp 1
                                          // DateTime targetDate =
                                          //     budget.createdAt.add(
                                          //   Duration(days: budget.duration),
                                          // );

                                          // // Calculate the difference between targetDate and current date
                                          // DateTime currentDate = DateTime.now();
                                          // Duration difference = targetDate
                                          //     .difference(currentDate);

                                          // // Format the difference as days
                                          // int differenceInDays =
                                          //     difference.inDays;

                                          return BudgetCard(
                                            category: budget.category,
                                            days: budget.duration,
                                            price: formatedAmount,
                                            usedPrice: usedformatedAmount,
                                            percentage: percentage,
                                            ontap: () {
                                              viewBudget(budget.category);
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  addBudget();
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 50.0,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  decoration: BoxDecoration(
                                    // color: Colors.blue,
                                    border: Border.all(
                                        width: 2, color: color.primaryColor),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  child: Center(
                                    child: (!_isLoading)
                                        ? Text(
                                            "Add Budget",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          )
                                        : CircularProgressIndicator(
                                            color: Colors.blue,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    // height: 400,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "My Loans",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoansPage()));
                                },
                                child: const Row(
                                  children: [
                                    Text("View all"),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const Divider(),
                          Container(
                            width: double.infinity,
                            // height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Tabs(
                                      title: "Credited",
                                      selectedIndex: _selectedLoanType,
                                      index: 0,
                                      isPressed: () {
                                        setState(
                                          () {
                                            changeLoanType(0);
                                            _loanTypeController.animateToPage(0,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.ease);
                                          },
                                        );
                                      },
                                    ),
                                    Tabs(
                                      title: "Debited",
                                      selectedIndex: _selectedLoanType,
                                      index: 1,
                                      isPressed: () {
                                        setState(
                                          () {
                                            changeLoanType(1);

                                            _loanTypeController.animateToPage(
                                              1,
                                              duration: const Duration(
                                                milliseconds: 500,
                                              ),
                                              curve: Curves.ease,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoansPage(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    // width: 90,
                                    // height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      border: Border.all(
                                          width: 1, color: Colors.black26),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.add),
                                        Text(
                                          "Add loan",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 400,
                            child: FutureBuilder<List<Loan>>(
                              future: fetchLoans,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return PageView(
                                    controller: _loanTypeController,
                                    children: [
                                      Container(
                                        child: ListView.builder(
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            double? interestAmount = snapshot
                                                    .data![index].interest! *
                                                (snapshot.data![index].amount /
                                                    100);

                                            // Calculate the difference in days
                                            int remainingDays = snapshot
                                                .data![index].loanDueDate
                                                .difference(DateTime.now())
                                                .inDays;
                                            if (snapshot
                                                    .data![index].loanType ==
                                                "own") {
                                              if (index < 10) {
                                                return LoanCard(
                                                    loanType: snapshot
                                                        .data![index].loanType,
                                                    actorName: snapshot
                                                        .data![index].actorName,
                                                    amount: snapshot
                                                        .data![index].amount,
                                                    amountPayed: snapshot
                                                        .data![index]
                                                        .amountPayed,
                                                    remainingDays:
                                                        remainingDays,
                                                    interestAmount:
                                                        interestAmount);
                                              } else {
                                                return const Center();
                                              }
                                            }
                                            return const Center();
                                          },
                                        ),
                                      ),
                                      Container(
                                        child: ListView.builder(
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            double? interestAmount = (snapshot
                                                        .data![index]
                                                        .interest! /
                                                    100) *
                                                snapshot.data![index].amount;

                                            // Calculate the difference in days
                                            int remainingDays = snapshot
                                                .data![index].loanDueDate
                                                .difference(DateTime.now())
                                                .inDays;
                                            if (snapshot
                                                    .data![index].loanType ==
                                                "owned") {
                                              if (index < 5) {
                                                return LoanCard(
                                                    loanType: snapshot
                                                        .data![index].loanType,
                                                    actorName: snapshot
                                                        .data![index].actorName,
                                                    amount: snapshot
                                                        .data![index].amount,
                                                    amountPayed: snapshot
                                                        .data![index]
                                                        .amountPayed,
                                                    remainingDays:
                                                        remainingDays,
                                                    interestAmount:
                                                        interestAmount);
                                              } else {
                                                return const Center();
                                              }
                                            }
                                            return const Center();
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                } else if (!snapshot.hasData) {
                                  return const Center(
                                    child: Text(
                                        "you have no loan added, you can add your loans any time ):"),
                                  );
                                }
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                  bottom: 80,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: () {
                      toggleTransactionCard();
                    },
                    child: Icon((addTransaction) ? Icons.close : Icons.add),
                  )),
              (addTransaction == true)
                  ? DraggableScrollableSheet(
                      initialChildSize:
                          0.7, // Initial size of the sheet (30% of the screen)
                      minChildSize:
                          0.1, // Minimum size of the sheet (10% of the screen)
                      maxChildSize:
                          0.8, // Maximum size of the sheet (80% of the screen)
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                          ),
                          child: ListView(
                            controller: scrollController,
                            children: [
                              Align(
                                child: Container(
                                  width: 100,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 50,
                                    // color: Colors.red,
                                    child: const TabBar(
                                      padding: EdgeInsets.all(0),
                                      labelColor: Colors.black,
                                      indicatorColor: Colors.black,
                                      labelPadding: EdgeInsets.all(0),
                                      unselectedLabelStyle: TextStyle(
                                        fontSize: 14,
                                        // fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                      ),
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                      tabs: [
                                        Tab(
                                          text: "New Transaction",
                                        ),
                                        Tab(text: "History"),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height /
                                        2.2,
                                    // color: Colors.red,
                                    child: TabBarView(
                                      children: [
                                        Container(
                                          child: ListView(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: 50,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 7),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.black26),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  elevation: 0,
                                                  // Initial Value
                                                  value: transactionTypevalue,
                                                  // Down Arrow Icon
                                                  icon: const Icon(Icons
                                                      .keyboard_arrow_down),

                                                  // Array list of items
                                                  items: transactionType
                                                      .map((String items) {
                                                    return DropdownMenuItem(
                                                      value: items,
                                                      child: Text(items),
                                                    );
                                                  }).toList(),
                                                  // After selecting the desired option,it will
                                                  // change button value to selected value
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      transactionTypevalue =
                                                          newValue!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              (transactionTypevalue ==
                                                      "expense")
                                                  ? Container(
                                                      width: double.infinity,
                                                      height: 50,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 7),
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                Colors.black26),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      child: DropdownButton(
                                                        isExpanded: true,
                                                        elevation: 0,
                                                        // Initial Value
                                                        value:
                                                            purposedropdownvalue,
                                                        // Down Arrow Icon
                                                        icon: const Icon(Icons
                                                            .keyboard_arrow_down),

                                                        // Array list of items
                                                        items: purposeItems.map(
                                                            (String items) {
                                                          return DropdownMenuItem(
                                                            value: items,
                                                            child: Text(items),
                                                          );
                                                        }).toList(),
                                                        // After selecting the desired option,it will
                                                        // change button value to selected value
                                                        onChanged:
                                                            (String? newValue) {
                                                          setState(() {
                                                            purposedropdownvalue =
                                                                newValue!;
                                                          });
                                                        },
                                                      ),
                                                    )
                                                  : Container(),
                                              (transactionTypevalue == "income")
                                                  ? SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Radio<String>(
                                                                value: 'salary',
                                                                groupValue:
                                                                    _selectedOption,
                                                                onChanged:
                                                                    (String?
                                                                        value) {
                                                                  setState(() {
                                                                    _selectedOption =
                                                                        value;
                                                                  });
                                                                },
                                                              ),
                                                              const Text(
                                                                "salary",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Radio<String>(
                                                                value: 'other',
                                                                groupValue:
                                                                    _selectedOption,
                                                                onChanged:
                                                                    (String?
                                                                        value) {
                                                                  setState(() {
                                                                    _selectedOption =
                                                                        value;
                                                                  });
                                                                },
                                                              ),
                                                              const Text(
                                                                "other sources",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Radio<String>(
                                                                value:
                                                                    'loan owned',
                                                                groupValue:
                                                                    _selectedOption,
                                                                onChanged:
                                                                    (String?
                                                                        value) {
                                                                  setState(() {
                                                                    _selectedOption =
                                                                        value;
                                                                  });
                                                                },
                                                              ),
                                                              const Text(
                                                                "loan owned",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                              (purposedropdownvalue ==
                                                          "target" &&
                                                      transactionTypevalue ==
                                                          "expense")
                                                  ? Container(
                                                      width: double.infinity,
                                                      height: 50,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 7),
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                Colors.black26),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      child: targetList.isEmpty
                                                          ? const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            )
                                                          : DropdownButton<
                                                              Target>(
                                                              value:
                                                                  selectedTarget,
                                                              hint: const Text(
                                                                  'Select a Target'),
                                                              onChanged: (Target?
                                                                  newValue) {
                                                                setState(() {
                                                                  selectedTarget =
                                                                      newValue!;
                                                                });
                                                              },
                                                              items: targetList
                                                                  .map((Target
                                                                      target) {
                                                                return DropdownMenuItem<
                                                                    Target>(
                                                                  value: target,
                                                                  child: Text(target
                                                                      .targetName),
                                                                );
                                                              }).toList(),
                                                            ),
                                                    )
                                                  : Container(),
                                              (purposedropdownvalue == "loan" &&
                                                      transactionTypevalue ==
                                                          "expense")
                                                  ? Container(
                                                      width: double.infinity,
                                                      height: 50,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 7),
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                Colors.black26),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      child: loanList.isEmpty
                                                          ? const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            )
                                                          : DropdownButton<
                                                              Loan>(
                                                              value:
                                                                  selectedLoan,
                                                              hint: const Text(
                                                                  'Select Loan'),
                                                              onChanged: (Loan?
                                                                  newValue) {
                                                                setState(() {
                                                                  selectedLoan =
                                                                      newValue!;
                                                                });
                                                              },
                                                              items: loanList
                                                                  .map((Loan
                                                                      loan) {
                                                                return DropdownMenuItem<
                                                                    Loan>(
                                                                  value: loan,
                                                                  child: Text(loan
                                                                      .actorName),
                                                                );
                                                              }).toList(),
                                                            ),
                                                    )
                                                  : Container(),
                                              InputBox(
                                                isText: false,
                                                title: "Amount",
                                                controller: _amountController,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 50,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 7),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.black26),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  elevation: 0,
                                                  // Initial Value
                                                  value: dropdownvalue,
                                                  // Down Arrow Icon
                                                  icon: const Icon(
                                                    Icons.keyboard_arrow_down,
                                                  ),

                                                  // Array list of items
                                                  items:
                                                      items.map((String items) {
                                                    return DropdownMenuItem(
                                                      value: items,
                                                      child: Text(items),
                                                    );
                                                  }).toList(),
                                                  // After selecting the desired option,it will
                                                  // change button value to selected value
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      dropdownvalue = newValue!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              InputBox(
                                                isText: true,
                                                title: "Description",
                                                controller:
                                                    _descriptionController,
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              MaterialButton(
                                                minWidth: double.infinity,
                                                height: 50,
                                                color: color.buttonColor,
                                                onPressed: () {
                                                  addTransactionFn();
                                                },
                                                child: (!isTransLoading)
                                                    ? const Text(
                                                        "Add Transaction",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      )
                                                    : const CircularProgressIndicator(
                                                        color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 60,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3.0),
                                                child: ListView.builder(
                                                  itemCount: tabsLength.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Tabs(
                                                      title: tabsLength[index],
                                                      index: index,
                                                      selectedIndex:
                                                          _selectedIndex,
                                                      isPressed: () {
                                                        changeTabs(index);
                                                        _pageController.animateToPage(
                                                            index,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                            curve: Curves.ease);
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: PageView(
                                                  controller: _pageController,
                                                  onPageChanged: (int page) {
                                                    setState(() {
                                                      _selectedIndex = page;
                                                      print(_selectedIndex);
                                                    });
                                                  },
                                                  children: <Widget>[
                                                    CustomPage(
                                                      content: FutureBuilder<
                                                          List<Transaction>>(
                                                        future:
                                                            fetchTransactions,
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            // print(snapshot.data!.length);
                                                            return ListView
                                                                .builder(
                                                              itemCount:
                                                                  snapshot.data!
                                                                      .length,
                                                              itemBuilder:
                                                                  (contaxt,
                                                                      index) {
                                                                String
                                                                    formattedDate =
                                                                    formatDateTime(snapshot
                                                                        .data![
                                                                            index]
                                                                        .date);
                                                                return HistoryCard(
                                                                  isPressed:
                                                                      () {},
                                                                  category: snapshot
                                                                      .data![
                                                                          index]
                                                                      .category,
                                                                  type: snapshot
                                                                      .data![
                                                                          index]
                                                                      .transactionType,
                                                                  description: snapshot
                                                                      .data![
                                                                          index]
                                                                      .description,
                                                                  price: snapshot
                                                                      .data![
                                                                          index]
                                                                      .amount,
                                                                  createdAt:
                                                                      formattedDate,
                                                                );
                                                              },
                                                            );
                                                          } else if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                "${snapshot.error}");
                                                          }
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    CustomPage(
                                                      content: FutureBuilder<
                                                          List<Transaction>>(
                                                        future:
                                                            fetchTransactions,
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            // print(snapshot.data!.length);
                                                            return ListView
                                                                .builder(
                                                                    itemCount:
                                                                        snapshot
                                                                            .data!
                                                                            .length,
                                                                    itemBuilder:
                                                                        (contaxt,
                                                                            index) {
                                                                      if (snapshot
                                                                              .data![index]
                                                                              .transactionType ==
                                                                          "income") {
                                                                        String
                                                                            formattedDate =
                                                                            formatDateTime(snapshot.data![index].date);
                                                                        return HistoryCard(
                                                                          isPressed:
                                                                              () {},
                                                                          category: snapshot
                                                                              .data![index]
                                                                              .category,
                                                                          type: snapshot
                                                                              .data![index]
                                                                              .transactionType,
                                                                          description: snapshot
                                                                              .data![index]
                                                                              .description,
                                                                          price: snapshot
                                                                              .data![index]
                                                                              .amount,
                                                                          createdAt:
                                                                              formattedDate,
                                                                        );
                                                                      } else {
                                                                        return Container();
                                                                      }
                                                                    });
                                                          } else if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                "${snapshot.error}");
                                                          }
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    CustomPage(
                                                      content: FutureBuilder<
                                                          List<Transaction>>(
                                                        future:
                                                            fetchTransactions,
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            // print(snapshot.data!.length);
                                                            return ListView
                                                                .builder(
                                                                    itemCount:
                                                                        snapshot
                                                                            .data!
                                                                            .length,
                                                                    itemBuilder:
                                                                        (contaxt,
                                                                            index) {
                                                                      if (snapshot
                                                                              .data![index]
                                                                              .transactionType ==
                                                                          "expense") {
                                                                        String
                                                                            formattedDate =
                                                                            formatDateTime(snapshot.data![index].date);
                                                                        return HistoryCard(
                                                                          isPressed:
                                                                              () {},
                                                                          category: snapshot
                                                                              .data![index]
                                                                              .category,
                                                                          type: snapshot
                                                                              .data![index]
                                                                              .transactionType,
                                                                          description: snapshot
                                                                              .data![index]
                                                                              .description,
                                                                          price: snapshot
                                                                              .data![index]
                                                                              .amount,
                                                                          createdAt:
                                                                              formattedDate,
                                                                        );
                                                                      } else {
                                                                        return Container();
                                                                      }
                                                                    });
                                                          } else if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                "${snapshot.error}");
                                                          }
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    )
                  : Container(),
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
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
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
                            color: CupertinoColors.white,
                          ),
                        ),
                        Text(
                          "${remainingDays.toString()} days",
                          style: const TextStyle(
                            fontSize: 11,
                            color: CupertinoColors.white,
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

class TabButton extends StatelessWidget {
  const TabButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      height: 45.0,
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }
}

class BudgetCard extends StatelessWidget {
  final String category;
  final int days;
  final String price;
  final String usedPrice;
  final double percentage;
  final Function()? ontap;

  const BudgetCard({
    super.key,
    required this.category,
    required this.days,
    required this.price,
    required this.usedPrice,
    required this.percentage,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    double newPercent = percentage * 0.01;
    double checkedPercentage = percentage;
    if (newPercent > 1.0) {
      newPercent = 1;
      checkedPercentage = 100;
    } else {
      newPercent = newPercent;
    }
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: 112,
        height: 90,
        // padding: EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          border: Border.all(width: 1, color: Colors.black12),
          boxShadow: [
            const BoxShadow(
              color: Color.fromARGB(255, 241, 241, 241),
              spreadRadius: 1.5,
              blurRadius: 1.5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                width: 110,
                height: 33,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 230, 230, 230),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: const TextStyle(
                        fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new CircularPercentIndicator(
                  radius: 18,
                  lineWidth: 3.0,
                  percent: newPercent,
                  animation: true,
                  progressColor: (newPercent < 0.8) ? Colors.green : Colors.red,
                  center: new Text(
                    "${double.parse(checkedPercentage.toStringAsFixed(1))}%",
                    style: const TextStyle(
                        fontSize: 7, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "$price",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "-$usedPrice",
                      style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange),
                    ),
                    Text(
                      "$days days",
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class TargetCard extends StatelessWidget {
  final String targetName;
  final double targetAmount;
  final double percent;
  final String timeRemained;
  final Function() ontap;
  final bool canItBeAccomplished;
  const TargetCard({
    super.key,
    required this.targetName,
    required this.targetAmount,
    required this.percent,
    required this.timeRemained,
    required this.ontap,
    required this.canItBeAccomplished,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: 190,
        height: 180.0,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2.0),
        decoration: BoxDecoration(
          // color: Colors.yellow[50],
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          border: Border.all(width: 2, color: Colors.green),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // width: 40,
                  height: 30,
                  child: new LinearPercentIndicator(
                    width: 100.0,
                    lineHeight: 8.0,
                    percent: percent,
                    progressColor: Colors.orange,
                  ),
                ),
                Text(
                  "${timeRemained} days",
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 226, 226, 226),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: (canItBeAccomplished)
                      ? Icon(
                          Icons.lock_open,
                          size: 12,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.lock,
                          size: 12,
                          color: Colors.red,
                        ),
                )
              ],
            ),
            Expanded(
              child: Container(
                // color: Colors.blue,
                child: Column(
                  children: [
                    Center(
                      child: Text(targetName),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Text(
                "${targetAmount.toString()} Tsh",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Tabs extends StatelessWidget {
  final String title;
  final int selectedIndex;
  final int index;
  final Function()? isPressed;
  const Tabs({
    super.key,
    required this.title,
    required this.selectedIndex,
    required this.index,
    required this.isPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isPressed,
      child: Container(
        height: 40.0,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: (index == selectedIndex) ? color.primaryColor : null,
          border: Border.all(
            width: 1,
            color: Colors.black12,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Center(
            child: Text(
          title,
          style: TextStyle(
              fontWeight:
                  (index == selectedIndex) ? FontWeight.w600 : FontWeight.w400,
              color: (index == selectedIndex) ? Colors.white : Colors.black),
        )),
      ),
    );
  }
}

class CustomPage extends StatelessWidget {
  final Widget content;

  const CustomPage({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return content;
  }
}

class HistoryCard extends StatelessWidget {
  final String? category;
  final String? type;
  final String? description;
  final double? price;
  final Function()? isPressed;
  final String createdAt;
  const HistoryCard({
    super.key,
    required this.isPressed,
    required this.category,
    required this.type,
    required this.description,
    required this.price,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70.0,
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      // margin: const EdgeInsets.symmetric(vertical: 3.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom:
              BorderSide(width: 1, color: Color.fromARGB(255, 224, 224, 224)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                  width: 47,
                  height: 47,
                  padding: const EdgeInsets.all(9.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(255, 150, 150, 150),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: const Icon(
                    Icons.emoji_transportation,
                    color: Colors.black54,
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    Text(description!, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (type == "expense")
                  ? Text(
                      "-${price.toString()}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.orange),
                    )
                  : Text(
                      "+${price.toString()}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Color.fromARGB(255, 63, 199, 68)),
                    ),
              Text(
                createdAt,
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
