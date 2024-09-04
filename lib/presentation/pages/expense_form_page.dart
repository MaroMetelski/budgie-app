import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:frontend/data/database.dart';
import 'package:frontend/data/models/transaction_model.dart';
import 'package:frontend/domain/transactions.dart';
import 'package:provider/provider.dart';

class ExpenseFormPage extends StatefulWidget {
  const ExpenseFormPage({super.key});

  @override
  State<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter();
  Account? selectedAccountFrom;
  Account? selectedAccountTo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add expense'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _formatter.format('0.00'),
                    inputFormatters: [
                      _formatter,
                    ],
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: false, decimal: true),
                  ),
                ),
              ],
            ),
            Consumer<TransactionController>(builder: (context, ctrl, child) {
              return Row(
                children: [
                  Expanded(
                    child: DropdownMenu<Account>(
                      initialSelection: ctrl.monetaryAssetAccounts.isNotEmpty
                          ? ctrl.monetaryAssetAccounts[0]
                          : null,
                      controller: _accountController,
                      requestFocusOnTap: true,
                      label: const Text('Account'),
                      onSelected: (Account? account) {
                        setState(() => selectedAccountFrom = account);
                      },
                      dropdownMenuEntries: ctrl.monetaryAssetAccounts
                          .map<DropdownMenuEntry<Account>>((Account account) {
                        return DropdownMenuEntry<Account>(
                          value: account,
                          label: account.name,
                          enabled: true,
                          style: MenuItemButton.styleFrom(
                            foregroundColor: Color(account.color),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: DropdownMenu<Account>(
                      initialSelection: ctrl.expenseAccounts.isNotEmpty
                          ? ctrl.expenseAccounts[0]
                          : null,
                      controller: _categoryController,
                      requestFocusOnTap: true,
                      label: const Text('Account'),
                      onSelected: (Account? account) {
                        setState(() => selectedAccountTo = account);
                      },
                      dropdownMenuEntries: ctrl.expenseAccounts
                          .map<DropdownMenuEntry<Account>>((Account account) {
                        return DropdownMenuEntry<Account>(
                          value: account,
                          label: account.name,
                          enabled: true,
                          style: MenuItemButton.styleFrom(
                            foregroundColor: Color(account.color),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }),
            Consumer<TransactionController>(builder: (context, ctrl, child) {
              return ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    num amount = _formatter.getUnformattedValue();
                    ctrl.addExpense(amount, selectedAccountFrom!,
                        selectedAccountTo!, "Description of the transaction...");
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Transaction added'),
                      duration: Duration(seconds: 1),
                    ));
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Submit'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
