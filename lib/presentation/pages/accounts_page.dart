import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/account_form_page.dart';
import 'package:frontend/presentation/widgets/main_drawer.dart';
import 'package:frontend/domain/transactions.dart';
import 'package:provider/provider.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => AccountsPageState();
}

class AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
      ),
      drawer: const MainDrawer(),
      body: Center(
        child: Column(
          children: [
            Consumer<TransactionController>(
              builder: (context, ctrl, child) => ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: ctrl.monetaryAssetAccounts.length,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: ListTile(
                      leading: Text(ctrl.monetaryAssetAccounts[index].balance.toString()),
                      title: Text(ctrl.monetaryAssetAccounts[index].name)),
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
            MaterialPageRoute(builder: (context) => const AccountFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
