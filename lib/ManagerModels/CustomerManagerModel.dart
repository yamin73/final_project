class CustomerManagerModel {
  final int? clientId;
  final String? userName;
  final String? phoneNumber;
  final String? email;
  final String? id;
  final String? lastVisit;
  final int? visitsCount;
  final String? createdDateTime;

  CustomerManagerModel({
    this.clientId,
    this.userName,
    this.phoneNumber,
    this.email,
    this.id,
    this.lastVisit,
    this.visitsCount,
    this.createdDateTime,
  });

  factory CustomerManagerModel.fromJson(Map<String, dynamic> json) {
    return CustomerManagerModel(
      clientId: json['clientID'],
      userName: json['UserName'],
      phoneNumber: json['PhoneNumber'],
      email: json['Email'],
      id: json['ID'],
      lastVisit: json['lastVisit'],
      visitsCount: json['visitsCount'] != null ? int.tryParse(json['visitsCount'].toString()) : 0,
      createdDateTime: json['createdDateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientID': clientId,
      'UserName': userName,
      'PhoneNumber': phoneNumber,
      'Email': email,
      'ID': id,
      'lastVisit': lastVisit,
      'visitsCount': visitsCount,
      'createdDateTime': createdDateTime,
    };
  }
}