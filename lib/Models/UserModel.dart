class User {
  User({
    this.id = "",
    this.name = "",
    this.phone = "",
    this.email ="",
    this.password ="",
  });
  String id;
  String name;
  String phone;
  String email;
  String password;




  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        password: json["password"]
      );
  Map<String, dynamic> tojson() => {
        id: ["id"],
        name: ["name"],
        phone: ["phone"],
        email: ["email"],
        password:["password"]

      };
}
