import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/expense_category_form_page.dart';
import 'package:frontend/presentation/widgets/main_drawer.dart';
import 'package:frontend/domain/transactions.dart';
import 'package:provider/provider.dart';

class ExpenseCategoriesPage extends StatefulWidget {
  const ExpenseCategoriesPage({super.key});

  @override
  State<ExpenseCategoriesPage> createState() => ExpenseCategoriesPageState();
}

class ExpenseCategoriesPageState extends State<ExpenseCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense categories'),
      ),
      drawer: const MainDrawer(),
      body: Center(
        child: Column(
          children: [
            Consumer<TransactionController>(
              builder: (context, ctrl, child) => ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: ctrl.expenseAccounts.length,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: ListTile(
                      tileColor: Color(ctrl.expenseAccounts[index].color),
                      leading: Text(ctrl.expenseAccounts[index].balance.toString()),
                      title: Text(ctrl.expenseAccounts[index].name)),
                  );
                }
              ),
            ),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExpenseCategoryFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
