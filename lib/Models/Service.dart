class ServiceType {
  ServiceType({
    this.name = "",
    this.date= "",


  });
  String name;
  String date;

  factory ServiceType.fromJson(Map<String, dynamic> json) => ServiceType(
        name: json["name"],

      );
  Map<String, dynamic> tojson() => {
        name: ["name"],

      };
}
