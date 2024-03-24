enum AccountType {
  monetaryAsset(),
  expense(),
  income(),
  payable(),
  receivable(),
  equity();
}

/// 'Account' is a generic endpoint model for all transactions, e.g. 'expense'
/// is simply a transaction from 'monetaryAsset' account to 'expense' account.
class AccountModel {
  final int? id;
  final String name;
  final AccountType type;

  const AccountModel({
    this.id,
    required this.name,
    required this.type,
  });

  AccountModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        type = AccountType.values.byName(map['type']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
    };
  }
}
