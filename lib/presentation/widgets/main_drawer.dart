import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/accounts_page.dart';
import 'package:frontend/presentation/pages/transactions_page.dart';
import 'package:frontend/presentation/pages/expense_categories_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      const DrawerHeader(child: Text('Budgee')),
      ListTile(
        title: const Text('All Transactions'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TransactionsPage()),
          );
        },
      ),
      ListTile(
          title: const Text('Accounts'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AccountsPage()),
            );
          }),
      ListTile(
        title: const Text('Expenses'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExpenseCategoriesPage()),
          );
        }),
    ]));
  }
}
