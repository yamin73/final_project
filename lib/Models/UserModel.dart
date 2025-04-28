class User {
  User({
    this.id = "",
    this.name = "",
    this.phone = "",
    this.email = "",
    this.password = "",
    this.carCount = 0,
    this.bookingCount = 0,
    this.nextBooking = "",
  });

  String id;
  String name;
  String phone;
  String email;
  String password;
  int carCount;
  int bookingCount;
  String nextBooking;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["userID"] ?? "",
    name: json["Name"] ?? "",
    phone: json["phoneNumber"] ?? "",
    email: json["email"] ?? "",
    password: json["password"] ?? "",
    carCount: json["carCount"] != null ? int.tryParse(json["carCount"].toString()) ?? 0 : 0,
    bookingCount: json["bookingCount"] != null ? int.tryParse(json["bookingCount"].toString()) ?? 0 : 0,
    nextBooking: json["nextBooking"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "userID": id,
    "Name": name,
    "phoneNumber": phone,
    "email": email,
    "password": password,
    "carCount": carCount,
    "bookingCount": bookingCount,
    "nextBooking": nextBooking,
  };
}