import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:frontend/data/database.dart';
import 'package:frontend/data/models/account_model.dart';
import 'package:frontend/data/models/transaction_model.dart';
import 'dart:collection';

/// high level "account" class.
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

class Expense {
  final int id;
  final Account from;
  final Account to;
  final String description;
  final num amount;

  Expense({
    required this.id,
    required this.from,
    required this.to,
    required this.description,
    required this.amount,
  });
}

class TransactionController extends ChangeNotifier {
  TransactionController._privateConstructor() {
    loadAll();
  }
  static final TransactionController instance = TransactionController._privateConstructor();

  final List<Account> _accounts = [];
  final DatabaseHelper database = DatabaseHelper.instance;

  List<Account> get monetaryAssetAccounts {
    return UnmodifiableListView(_accounts
        .where((element) => element.type == AccountType.monetaryAsset));
  }

  List<Account> get expenseAccounts {
    return UnmodifiableListView(
        _accounts.where((element) => element.type == AccountType.expense));
  }

  /// Refresh list and balance of all accounts.
  loadAll() async {
    _accounts.clear();
    List<AccountModel> data = await database.getAccounts();
    for (var acc in data) {
      // //
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
    notifyListeners();
  }

  Future<int> addMonetaryAssetAccount(String name, int color) async {
    AccountModel model =
        AccountModel(name: name, type: AccountType.monetaryAsset, color: color);
    int id = await database.addAccount(model);
    Account account =
        Account(id: id, name: name, type: AccountType.monetaryAsset, color: color);
    _accounts.add(account);
    notifyListeners();
    return id;
  }

  Future<int> addExpenseAccount(String name, int color) async {
    AccountModel model = AccountModel(name: name, type: AccountType.expense, color: color);
    int id = await database.addAccount(model);
    Account account = Account(id: id, name: name, type: AccountType.expense, color: color);
    _accounts.add(account);
    notifyListeners();
    return id;
  }
}
