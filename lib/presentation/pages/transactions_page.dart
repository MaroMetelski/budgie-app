import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/expense_form_page.dart';
import 'package:frontend/presentation/widgets/main_drawer.dart';
import 'package:frontend/data/database.dart';
import 'package:frontend/data/models/transaction_model.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => TransactionsPageState();
}

class TransactionsPageState extends State<TransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      drawer: const MainDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder<List<TransactionModel>>(
              future: DatabaseHelper.instance.getTransactions(null),
              builder: (BuildContext context, AsyncSnapshot<List<TransactionModel>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text('Loading...'));
                }
                return ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: snapshot.data!.map((transaction) {
                    return Center(
                      child: ListTile(
                        leading: Text(transaction.amount.toString()),
                        title: Text(transaction.description),
                      ),
                    );
                  }).toList(),
                );
              }
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExpenseFormPage()),
          ).then((_) {
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
