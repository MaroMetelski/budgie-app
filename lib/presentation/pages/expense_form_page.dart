import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:frontend/data/database.dart';
import 'package:frontend/data/models/transaction_model.dart';

enum CategoryLabel {
  groceries('Groceries', Colors.blue),
  rent('Rent', Colors.amber);

  const CategoryLabel(this.label, this.color);
  final String label;
  final Color color;
}

class ExpenseFormPage extends StatefulWidget {
  const ExpenseFormPage({super.key});

  @override
  State<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryController = TextEditingController();
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter();
  CategoryLabel? selectedCategory;

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
            DropdownMenu<CategoryLabel>(
              initialSelection: CategoryLabel.groceries,
              controller: _categoryController,
              requestFocusOnTap: true,
              label: const Text('Category'),
              onSelected: (CategoryLabel? category) {
                setState(() => selectedCategory = category);
              },
              dropdownMenuEntries: CategoryLabel.values
                  .map<DropdownMenuEntry<CategoryLabel>>(
                      (CategoryLabel category) {
                return DropdownMenuEntry<CategoryLabel>(
                  value: category,
                  label: category.label,
                  enabled: true,
                  style: MenuItemButton.styleFrom(
                    foregroundColor: category.color,
                  ),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  num amount = _formatter.getUnformattedValue();
                  TransactionModel transaction = TransactionModel(
                    dateTime: DateTime.now().millisecondsSinceEpoch,
                    accountFromId: 1,
                    accountToId: 2,
                    amount: amount,
                    description: 'hello this is me, new transaction',
                  );
                  DatabaseHelper.instance.addTransaction(transaction);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Transaction added'),
                    duration: Duration(seconds: 1),
                  ));
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
