class Customer {
  Customer({
    this.id = "",
    this.name = "",
    this.phone = "",
    this.note = "",
  });
  String id;
  String name;
  String phone;
  String note;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        note: json["note"],
      );
  Map<String, dynamic> tojson() => {
        id: ["id"],
        name: ["name"],
        phone: ["phone"],
        note: ["note"],
      };
}
