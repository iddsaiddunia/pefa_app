import 'package:flutter/material.dart';
import 'package:pfa_app/color_themes.dart';
import 'package:pfa_app/components.dart';

class LoansPage extends StatefulWidget {
  const LoansPage({super.key});

  @override
  State<LoansPage> createState() => _LoansPageState();
}

class _LoansPageState extends State<LoansPage> {
  String dropdownvalue = 'Own';
  DateTime selectedDate = DateTime.now();

  // List of items in our dropdown menu
  var items = [
    'Own',
    'Owned',

  ];


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
                labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    InputBox(title: "Credit/Debited to"),
                    InputBox(title: "Amount"),

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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.calendar_month),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                    Text(selectedDate.toString()),
                    InputBox(title: "Description"),
                    SizedBox(height: 20,),
                    MaterialButton(
                      color: color.buttonColor,
                      minWidth: double.infinity,
                      height:55,
                      onPressed: (){}, child: Text("Add Loan",style: TextStyle(color: Colors.white),),),
                  ],
                ),
              ),
              Container(
                child: Text("hello"),
              )
            ],),),

            ],
          ),
        ),
      ),
    );
  }
}
