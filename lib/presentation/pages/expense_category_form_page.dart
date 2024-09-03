import 'package:flutter/material.dart';
import 'package:frontend/domain/transactions.dart';
import 'dart:math' as math;

class ExpenseCategoryFormPage extends StatefulWidget {
  const ExpenseCategoryFormPage({super.key});

  @override
  State<ExpenseCategoryFormPage> createState() => _ExpenseCategoryFormPageState();
}

class _ExpenseCategoryFormPageState extends State<ExpenseCategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add expense category'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String name = _nameController.text;
                  var genColorId = math.Random().nextInt(Colors.primaries.length);
                  Color color = Colors.primaries[genColorId];
                  TransactionController.instance.addExpenseAccount(name, color.value);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Expense category added'),
                    duration: Duration(seconds: 1),
                  ));
                  Navigator.pop(context);
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
