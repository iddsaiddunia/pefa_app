import 'package:flutter/material.dart';
import 'package:pfa_app/color_themes.dart';

class AddNewTargetPage extends StatefulWidget {
  const AddNewTargetPage({super.key});

  @override
  State<AddNewTargetPage> createState() => _AddNewTargetPageState();
}

class _AddNewTargetPageState extends State<AddNewTargetPage> {
  DateTime selectedDate = DateTime.now();

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Set new Target"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black26),
                borderRadius: BorderRadius.all(Radius.circular(10),),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Enter target",
                  hintStyle: TextStyle(fontSize: 14),
                  border: InputBorder.none
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black26),
                borderRadius: BorderRadius.all(Radius.circular(10),),
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter target amount",
                  hintStyle: TextStyle(fontSize: 14),
                  border: InputBorder.none
                ),
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
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black26),
                borderRadius: BorderRadius.all(Radius.circular(10),),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Enter target description",
                  hintStyle: TextStyle(fontSize: 14),
                  border: InputBorder.none
                ),
              ),
            ),
            SizedBox(height: 50,),
            MaterialButton(
              height: 55.0,
              minWidth: double.infinity,
              textColor: Colors.white,
              color: color.buttonColor,
              onPressed: (){}, child: Text("Add target"),),
          ],
        ),
      ),
    );
  }
}
