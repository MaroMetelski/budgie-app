import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:frontend/data/models/transaction_model.dart';
import 'package:frontend/data/models/account_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'budgee.db');
    // deleteDatabase(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('''PRAGMA foreign_keys = ON''');
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS account(
        id INTEGER PRIMARY KEY,
        name TEXT UNIQUE NOT NULL CHECK( LENGTH(name) <= 100 ),
        type TEXT NOT NULL
      )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS _transaction(
        id INTEGER PRIMARY KEY,
        amount REAL NOT NULL,
        datetime INTEGER NOT NULL,
        accountFromId INTEGER NOT NULL,
        accountToId INTEGER NOT NULL,
        description TEXT NULL DEFAULT NULL CHECK ( LENGTH(description) <= 280 ),
        FOREIGN KEY(accountFromId) REFERENCES account(id),
        FOREIGN KEY(accountToId) REFERENCES account(id)
      )''');
  }

  Future<List<TransactionModel>> getTransactions(String? where) async {
    Database db = await instance.database;
    var items = await db.query('_transaction', orderBy: 'datetime', where: where);
    List<TransactionModel> itemList = items.isNotEmpty
        ? items.map((c) => TransactionModel.fromMap(c)).toList()
        : [];
    return itemList;
  }

  Future<int> addTransaction(TransactionModel transaction) async {
    Database db = await instance.database;
    return await db.insert('_transaction', transaction.toMap());
  }

  Future<int> removeTransaction(int id) async {
    Database db = await instance.database;
    return await db.delete('_transaction', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> addAccount(AccountModel account) async {
    Database db = await instance.database;
    return await db.insert('account', account.toMap());
  }

  Future<List<AccountModel>> getAccounts() async {
    Database db = await instance.database;
    var items = await db.query('account', orderBy: 'name');
    List<AccountModel> accountList = items.isNotEmpty
        ? items.map((c) => AccountModel.fromMap(c)).toList()
        : [];
    return accountList;
  }
}
