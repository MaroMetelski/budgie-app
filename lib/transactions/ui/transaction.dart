import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: const Scaffold(
        body: TransactionList(),
      ),
      theme: ThemeData(
      primarySwatch: Colors.blue,
      ),
    )
  );
}

class TransactionItem extends StatelessWidget {
  final double amount;
  final String type;
  final String from;
  final String to;
  final String who;
  final String description;

  const TransactionItem({
    super.key,
    required this.amount,
    required this.type,
    required this.from,
    required this.to,
    this.who = "",
    this.description = "",
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(to),
            Text("from $from"),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(type),
            Text(amount.toStringAsFixed(2)),
          ],
        ),
      ]
    );
  }
}

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});
  @override
  State<TransactionList> createState() => _TransactionListState();
}

final List<double> dummyList = List.generate(10, (index) { return index.toDouble(); });

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => TransactionItem(
          amount: dummyList[index],
          type: "expense",
          from: "cash",
          to: "groceries",
          who: "Biedronka",
          description: "Codzienne zakupy"
        ),
      ),
    );
  }
}
