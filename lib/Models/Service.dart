class Service {
  Service({
    this.name = "",
    this.date= "",


  });
  String name;
  String date;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        name: json["name"],

      );
  Map<String, dynamic> tojson() => {
        name: ["name"],

      };
}
