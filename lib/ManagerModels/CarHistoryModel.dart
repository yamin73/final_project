class CarHistoryModel {
  final String? carId;
  final String? carBrand;
  final String? carModel;
  final String? carLicense;
  final String? carColor;
  final String? year;
  final String? ownerName;
  final String? ownerPhone;
  final String? lastVisit;
  final int? visitsCount;

  CarHistoryModel({
    this.carId,
    this.carBrand,
    this.carModel,
    this.carLicense,
    this.carColor,
    this.year,
    this.ownerName,
    this.ownerPhone,
    this.lastVisit,
    this.visitsCount,
  });

  factory CarHistoryModel.fromJson(Map<String, dynamic> json) {
    return CarHistoryModel(
      carId: json['carID'],
      carBrand: json['carBrand'],
      carModel: json['carModel'],
      carLicense: json['carLicense'],
      carColor: json['color'],
      year: json['year'],
      ownerName: json['ownerName'],
      ownerPhone: json['ownerPhone'],
      lastVisit: json['lastVisit'],
      visitsCount: json['visitsCount'] != null ? int.tryParse(json['visitsCount'].toString()) : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'carID': carId,
      'carBrand': carBrand,
      'carModel': carModel,
      'carLicense': carLicense,
      'color': carColor,
      'year': year,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'lastVisit': lastVisit,
      'visitsCount': visitsCount,
    };
  }
}