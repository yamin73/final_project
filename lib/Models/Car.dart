class Car {
  Car({
    this.carID = "",
    this.carName= "",

  });
  String carID;
  String carName;


  factory Car.fromJson(Map<String, dynamic> json) => Car(
    carID: json["carID"],
    carName: json["carName"],




  );

  get date => null;
  Map<String, dynamic> tojson() => {
    carID: ["carID"],
    carName: ["carName"],



  };
}