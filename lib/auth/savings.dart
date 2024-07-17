import 'package:flutter/material.dart';
import 'package:pfa_app/models/saving_model.dart';
import 'package:pfa_app/services/saving_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  SavingService _savingService = SavingService();
  late Future<List<Saving>> fetchSavings;

  double _totalSavedAmount = 0.0;

  @override
  void initState() {
    super.initState();
    fetchSavings = SavingService.getSavings();
    _loadTotalSavingAmount();
  }

  void _loadTotalSavingAmount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var userId = prefs.getInt('userId');
      double totalAmount = await SavingService.getTotalAmountForUser(userId!);
      setState(() {
        _totalSavedAmount = totalAmount;
        print(_totalSavedAmount);
      });
    } catch (e) {
      print('Error loading total amount: $e');
    }
  }

  String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Saving>>(
        future: fetchSavings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 150.0,
                  backgroundColor: Colors.blue,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Row(
                      children: [
                        // Text(
                        //   'Total Saving',
                        //   style: TextStyle(fontSize: 12),
                        // ),
                        Text('$_totalSavedAmount Tsh'),
                      ],
                    ),
                    // background: Image.network(
                    //   'https://via.placeholder.com/500x200',
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  // actions: [
                  //   IconButton(
                  //     onPressed: () {},
                  //     icon: const Icon(Icons.add),
                  //   ),
                  //   IconButton(
                  //     onPressed: () {},
                  //     icon: const Icon(Icons.remove),
                  //   ),
                  // ],
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      // return ListTile(
                      //   title: Text(snapshot.data![index].toString()),
                      // );
                      String formatedDate =
                          formatDate(snapshot.data![index].createdAt);
                      return SavingCard(
                          amount: snapshot.data![index].amount,
                          date: formatedDate);
                    },
                    childCount: snapshot.data!.length,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class SavingCard extends StatelessWidget {
  final double amount;
  final String date;
  const SavingCard({super.key, required this.amount, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 70,
        margin: const EdgeInsets.symmetric(vertical: 2.0),
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
        child: Row(
          children: [
            Container(
              width: 50,
              height: 70,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 228, 228, 228),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Text(
                    "+${amount.toString()} Tsh",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    "$date",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
