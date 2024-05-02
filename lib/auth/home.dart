import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pfa_app/auth/add_loan.dart';
import 'package:pfa_app/auth/add_target.dart';
import 'package:pfa_app/color_themes.dart';

import '../components.dart';

import '../components.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController(initialPage: 0);
  PageController _loanTypeController = PageController(initialPage: 0);
  int _selectedIndex = 0;
  int _selectedLoanType = 0;
  String dropdownvalue = 'Cash';
  // List of items in our dropdown menu
  var items = [
    'Cash',
    'Mobile Transaction',
    'Bank Transaction',

  ];

  List<String> tabsLength = ["All", "Income", "Expense"];
  List myTargets = [
    "Laptop",
    "Car",
    "House",
  ];

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

  addTargetWindow() {
    showDialog(
        context: context,
        builder: (BuildContext contex) {
          return AlertDialog(
            title: Text(
              "Add new Loan",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),
            actions: [IconButton(onPressed: () {}, icon: Icon(Icons.cancel))],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text("hello")],
            ),
          );
        });
  }

  addLoanWindow() {
    showDialog(
        context: context,
        builder: (BuildContext contex) {
          return AlertDialog(
            title: Text(
              "Add new Loan",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),
            actions: [
              MaterialButton(
                elevation: 0,
                color: CupertinoColors.activeGreen,
                onPressed: () {},
                child: Text("Add Loan"),
              ),
              MaterialButton(
                elevation: 0,
                color: Colors.redAccent,
                onPressed: () {},
                child: Text("Cancel"),
              ),
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        // drawer:Drawer(),
        backgroundColor: Color.fromARGB(50, 241, 241, 230),

        body: Stack(
          children: [
            ListView(
              children: [
                SizedBox(
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
                            Text(
                              "My Targets",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddNewTargetPage(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 13, vertical: 8),
                                decoration: BoxDecoration(
                                  color: color.primaryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Add target",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: myTargets.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (contaxt, index) {
                              return TargetCard();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    // height: 10.0,
                    ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      border: Border.all(width: 1, color: Colors.black12),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 45,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(width: 1, color: Colors.blue),
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(8))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Savings",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                "120000 Tsh",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10),
                              ),
                              border:
                                  Border.all(width: 1, color: Colors.black12),
                            ),
                            child: Row(
                              children: [
                                SavingCard(),
                                SavingCard(),
                                SavingCard(),
                              ],
                            ),
                          ),
                        )
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
                          children: [
                            Text(
                              "My Loans",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
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

                                          _loanTypeController.animateToPage(1,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.ease);
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
                                      builder: (context) => AddLoanPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  // width: 90,
                                  // height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    border: Border.all(width: 1, color: Colors.black38),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Row(
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
                          child: PageView(
                            controller: _loanTypeController,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: ListView(
                                    children: [
                                      LoanCard(),
                                      LoanCard(),
                                      LoanCard(),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: Text("B"),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            DraggableScrollableSheet(
              initialChildSize:
                  0.1, // Initial size of the sheet (30% of the screen)
              minChildSize:
                  0.1, // Minimum size of the sheet (10% of the screen)
              maxChildSize:
                  0.7, // Maximum size of the sheet (80% of the screen)
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        Align(
                          child: Container(
                            width: 100,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 50,
                              // color: Colors.red,
                              child: TabBar(
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
                                    fontSize: 14, fontWeight: FontWeight.w700),
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
                              height: MediaQuery.of(context).size.height / 2.2,
                              // color: Colors.red,
                              child: TabBarView(
                                children: [
                                  Container(
                                    child: Column(children: [
                                      InputBox(title: "Amount",),
                                      Container(
                                        width: double.infinity,
                                        height: 55,
                                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
                                        margin: EdgeInsets.symmetric(vertical: 8),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: Colors.black26),
                                          borderRadius: BorderRadius.all(Radius.circular(10),),
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
                                      InputBox(title: "Description",),
                                      MaterialButton(
                                        minWidth: double.infinity,
                                        height: 50,
                                        color: color.buttonColor,
                                        onPressed: (){}, child: Text("Add Transaction",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),)
                                    ],),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 60,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 3.0),
// color: Colors.black12,
                                          child: ListView.builder(
                                            itemCount: tabsLength.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Tabs(
                                                title: tabsLength[index],
                                                index: index,
                                                selectedIndex: _selectedIndex,
                                                isPressed: () {
                                                  changeTabs(index);
// print(index);
                                                  _pageController.animateToPage(
                                                      index,
                                                      duration: const Duration(
                                                          milliseconds: 500),
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
                                                content: Container(
                                                  width: double.infinity,
                                                  height: 240,
// color: Colors.red,
                                                  child: ListView(
                                                    children: [
                                                      HistoryCard(
                                                        isPressed: () {
// Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsPage(id:1)));
                                                        },
                                                      ),
                                                      HistoryCard(
                                                        isPressed: () {
// Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsPage(id:2)));
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              CustomPage(
                                                content: Text('Page 2 Content'),
                                              ),
                                              CustomPage(
                                                content: Text('Page 2 Content'),
                                              ),
                                              CustomPage(
                                                content: Text('Page 2 Content'),
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
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}



class LoanCard extends StatelessWidget {
  const LoanCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 97,
      margin: EdgeInsets.symmetric(vertical: 4.0),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: Colors.black12,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 241, 241, 241),
                blurRadius: 1.5,
                spreadRadius: 1.5)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "To-",
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    "John Doe",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black54),
                  ),
                ],
              ),

              Row(
                children: [
                  Text(
                    "Amount-",
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    "15,000",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Interest-",
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    "3,000",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black54),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Payed-",
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    "5,000",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black54),
                  ),
                  Container(
                    width: 70,
                    height: 35,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "remaining",
                          style: TextStyle(
                              fontSize: 9, color: CupertinoColors.white),
                        ),
                        Text(
                          "26 days",
                          style: TextStyle(
                              fontSize: 11,
                              color: CupertinoColors.white,
                              fontWeight: FontWeight.w600),
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
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }
}

class SavingCard extends StatelessWidget {
  const SavingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 87,
      // padding: EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        border: Border.all(width: 1, color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 241, 241, 241),
            spreadRadius: 1.5,
            blurRadius: 1.5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Container(
            //   width: 45,
            //   height: 45,
            //   decoration: BoxDecoration(
            //     // color: Colors.red,
            //     borderRadius: BorderRadius.all(
            //       Radius.circular(25),
            //     ),
            //     border: Border.all(width: 3, color: Colors.blue),
            //   ),
            // ),
            new CircularPercentIndicator(
              radius: 25,
              lineWidth: 3.0,
              percent: 0.7,
              animation: true,
              progressColor: Colors.greenAccent,
              center: new Text(
                "70.0%",
                style: TextStyle(fontSize: 10),
              ),
            ),
            Text(
              "12000",
              style: TextStyle(fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}

class TargetCard extends StatelessWidget {
  const TargetCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180.0,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        // color: Colors.yellow[50],
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        border: Border.all(width: 2, color: Colors.green),
      ),
      child: Column(
        children: [
          Container(
            width: 180,
            height: 35,
            child: new LinearPercentIndicator(
              width: 100.0,
              lineHeight: 8.0,
              percent: 0.5,
              progressColor: Colors.orange,
            ),
          ),
          Expanded(
            child: Container(
              // color: Colors.blue,
              child: Column(
                children: [
                  Center(
                    child: Text("Buying new laptop"),
                  ),
                  Center(
                    child: Text(
                      "800K",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
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
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: (index == selectedIndex) ? color.primaryColor : null,
          border: Border.all(
            width: 1,
            color: Colors.black12,
          ),
          borderRadius: BorderRadius.all(
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
  final Function()? isPressed;
  const HistoryCard({super.key, required this.isPressed});

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
                  child: Icon(
                    Icons.emoji_transportation,
                    color: Colors.black54,
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Transport",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12)),
                    Text("Daladala", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "-5,800",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.orange),
              ),
              Text(
                "Apr 21",
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
