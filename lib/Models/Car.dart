class Car {
  final String? carID;
  final String? carName;
  final String? carModel;
  final String? carBrand;
  final String? carLicense;
  final String? year;
  final String? color;
  final String? ownerID;

  Car({
    this.carID,
    this.carName,
    this.carModel,
    this.carBrand,
    this.carLicense,
    this.year,
    this.color,
    this.ownerID,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      carID: json['carID'],
      carName: json['carName'],
      carModel: json['carModel'],
      carBrand: json['carBrand'],
      carLicense: json['carLicense'],
      year: json['year'],
      color: json['color'],
      ownerID: json['ownerID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'carID': carID,
      'carName': carName,
      'carModel': carModel,
      'carBrand': carBrand,
      'carLicense': carLicense,
      'year': year,
      'color': color,
      'ownerID': ownerID,
    };
  }
}