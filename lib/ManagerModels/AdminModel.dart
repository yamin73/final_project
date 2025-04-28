class AdminModel {
  final String? adminId;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? role;
  final String? createdDate;
  final String? lastLogin;

  AdminModel({
    this.adminId,
    this.name,
    this.email,
    this.phoneNumber,
    this.role,
    this.createdDate,
    this.lastLogin,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      adminId: json['adminId'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      createdDate: json['createdDate'],
      lastLogin: json['lastLogin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adminId': adminId,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'createdDate': createdDate,
      'lastLogin': lastLogin,
    };
  }
}