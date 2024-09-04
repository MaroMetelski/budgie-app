import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:frontend/data/database.dart';
import 'package:frontend/data/models/account_model.dart';
import 'package:frontend/data/models/transaction_model.dart';
import 'dart:collection';

/// Application level Account model. This is an account in "double-entry sense",
/// meaning it is used to represent monetary accounts, expense categories and such.
class Account {
  final int id;
  final AccountType type;
  final String name;
  final int color;
  num credit;
  num debit;

  Account(
      {required this.id,
      required this.name,
      required this.type,
      required this.color,
      this.credit = 0,
      this.debit = 0});

  num get balance {
    return debit - credit;
  }
}

/// Transaction between two accounts. Primary transaction mechanism in the application.
/// For example, an "expense" is simply a transaction between a monetary accounts
/// and expense category acccount.
class Transaction {
  final int id;
  final DateTime datetime;
  final Account from;
  final Account to;
  final String description;
  final num amount;

  Transaction({
    required this.id,
    required this.from,
    required this.datetime,
    required this.to,
    required this.description,
    required this.amount,
  });
}

class TransactionController extends ChangeNotifier {
  TransactionController._privateConstructor() {
    loadAllAccounts();
  }
  static final TransactionController instance =
      TransactionController._privateConstructor();

  // List of accounts and balances is kept and updated locally.
  // This means transactions can easily refer to accounts without fetching.
  final List<Account> _accounts = [];
  final DatabaseHelper database = DatabaseHelper.instance;

  List<Account> get monetaryAssetAccounts {
    // TODO: This does not work well...
    loadAllAccounts();
    return UnmodifiableListView(_accounts
        .where((element) => element.type == AccountType.monetaryAsset));
  }

  List<Account> get expenseAccounts {
    // TODO: This does not work well...
    loadAllAccounts();
    return UnmodifiableListView(
        _accounts.where((element) => element.type == AccountType.expense));
  }

  /// Refresh list and balance of all accounts and categories.
  loadAllAccounts() async {
    _accounts.clear();
    List<AccountModel> data = await database.getAccounts();
    for (var acc in data) {
      // TODO: Do a DB query that will calculate the sums.
      List<TransactionModel> transactionsFrom =
          await database.getTransactions('accountFromId = ${acc.id}');
      List<TransactionModel> transactionsTo =
          await database.getTransactions('accountToId = ${acc.id}');
      num credit = transactionsFrom.fold(
          0, (val, transaction) => val + transaction.amount);
      num debit = transactionsTo.fold(
          0, (val, transaction) => val + transaction.amount);
      // Add account to runtime context.
      _accounts.add(Account(
          id: acc.id!,
          type: acc.type,
          name: acc.name,
          color: acc.color,
          credit: credit,
          debit: debit));
    }
  }

  Future<int> addMonetaryAssetAccount(String name, int color) async {
    AccountModel model =
        AccountModel(name: name, type: AccountType.monetaryAsset, color: color);
    int id = await database.addAccount(model);
    // Account account = Account(
    //     id: id, name: name, type: AccountType.monetaryAsset, color: color);
    // _accounts.add(account);

    loadAllAccounts();
    notifyListeners();
    return id;
  }

  Future<int> addExpenseAccount(String name, int color) async {
    AccountModel model =
        AccountModel(name: name, type: AccountType.expense, color: color);
    int id = await database.addAccount(model);
    // Account account =
    //     Account(id: id, name: name, type: AccountType.expense, color: color);
    // _accounts.add(account);

    loadAllAccounts();
    notifyListeners();
    return id;
  }

  Future<int> addExpense(
      num amount, Account from, Account to, String description) async {
    TransactionModel model = TransactionModel(
        dateTime: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        accountFromId: from.id,
        accountToId: to.id,
        description: description,
        amount: amount);
    int id = await database.addTransaction(model);
    // Transaction expense =
    //   Transaction(id: id, from: from, to: to, amount: amount, description: description);
    // update runtime balances.
    // int idxFrom = _accounts.indexWhere((element) => element.id == from.id);
    // int idxTo = _accounts.indexWhere((element) => element.id == to.id);
    // _accounts[idxFrom].credit = amount;
    // _accounts[idxTo].debit = amount;

    // reload state
    loadAllAccounts();
    notifyListeners();
    return id;
  }

  Future<List<Transaction>> getAllTransactions() async {
    /// make sure all accounts are up to date.
    loadAllAccounts();
    List<TransactionModel> models =
        await DatabaseHelper.instance.getTransactions(null);
    List<Transaction> transactions = models.map((model) {
      return Transaction(
        id: model.id!, // id is always set when fetching from the database.
        description: model.description,
        amount: model.amount,
        datetime: DateTime.fromMillisecondsSinceEpoch(model.dateTime * 1000),
        from: _accounts
            .firstWhere((account) => account.id == model.accountFromId),
        to: _accounts.firstWhere((account) => account.id == model.accountToId),
      );
    }).toList();
    return transactions;
  }
}
