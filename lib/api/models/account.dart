class Account {
  final String id;
  final String name;
  final String type;
  final String extraType;
  final String description;

  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.extraType,
    required this.description,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json["id"],
      name: json["name"],
      type: json["type"],
      extraType: json["extra_type"],
      description: json["description"],
    );
  }
}
