class Service {
  Service({
    this.id = "",
    this.name = "",

  });
  String id;
  String name;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],

      );
  Map<String, dynamic> tojson() => {
        id: ["id"],
        name: ["name"],

      };
}
