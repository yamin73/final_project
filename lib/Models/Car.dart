class Car {
  Car({
    this.type = "",
    this.module= "",
    this.carLicense="",
    this.color="",
    this.ownerID="",

  });
  String type;
  String module;
  String carLicense;
  String color;
  String ownerID;

  factory Car.fromJson(Map<String, dynamic> json) => Car(
    type: json["type"],
    module: json["module"],
    carLicense: json["carLicense"],
    color: json["color"],
    ownerID: json["ownerID"]




  );
  Map<String, dynamic> tojson() => {
    type: ["type"],
    module: ["module"],
    carLicense:["carLicense"],
    color:["color"],
    ownerID:["ownerID"],


  };
}