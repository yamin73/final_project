class Customer {
  final String id;
  final String name;
  final String phone;
  final String note;

  Customer({
    this.id = "",
    this.name = "",
    this.phone = "",
    this.note = "",
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"] ?? "",
    name: json["name"] ?? "",
    phone: json["phone"] ?? "",
    note: json["note"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "note": note,
  };
}