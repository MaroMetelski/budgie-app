/// 'TransactionModel' is a generic "flow" database model for defining a value
/// transfer between two accounts. Based on the account types the transaction
/// will be interpreted differently, e.g. as 'expense' or 'loan given'.
/// This is to be decided by application.
class TransactionModel {
  final int? id;

  /// Unix timestamp
  final int dateTime;

  /// Id of "from" (credit) account
  final int accountFromId;

  /// Id of "to" (debit) account
  final int accountToId;
  final num amount;
  final String description;

  const TransactionModel({
    this.id,
    required this.dateTime,
    required this.accountFromId,
    required this.accountToId,
    required this.amount,
    required this.description,
  });

  TransactionModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        dateTime = map['datetime'],
        accountFromId = map['accountFromId'],
        accountToId = map['accountFromId'],
        amount = map['amount'],
        description = map['description'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'datetime': dateTime,
      'accountFromId': accountFromId,
      'accountToId': accountToId,
      'amount': amount,
      'description': description,
    };
  }
}
