class ServiceType {
  final String id;
  final String name;
  final String date;
  final String description;
  final double price;

  ServiceType({
    this.id = "",
    this.name = "",
    this.date = "",
    this.description = "",
    this.price = 0.0,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) => ServiceType(
    id: json["id"] ?? "",
    name: json["name"] ?? "",
    date: json["date"] ?? "",
    description: json["description"] ?? "",
    price: json["price"] != null ? double.tryParse(json["price"].toString()) ?? 0.0 : 0.0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "date": date,
    "description": description,
    "price": price,
  };
}