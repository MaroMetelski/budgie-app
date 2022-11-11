class Entry {
  final String id;
  final String amount;
  final String who;
  final String date;
  final String cr;
  final String dr;
  final String description;
  final List<String> tags;

  const Entry({
    required this.id,
    required this.amount,
    required this.who,
    required this.date,
    required this.cr,
    required this.dr,
    required this.description,
    required this.tags,
  });

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json["id"],
      amount: json["amount"],
      who: json["who"],
      date: json["when"],
      cr: json["credit_account"],
      dr: json["debit_account"],
      description: json["description"],
      tags: json["tags"].isNotEmpty ? List<String>.from(json["tags"]) : <String>[],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'who': who,
    'date': date,
    'credit_account': cr,
    'debit_account': dr,
    'description': description,
    'tags': tags,
  };
}
