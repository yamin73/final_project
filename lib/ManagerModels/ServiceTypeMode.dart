class ServiceTypeModel {
  final String? serviceTypeId;
  final String? name;
  final String? description;
  final double? price;
  final int? durationMinutes;
  final bool isActive;

  ServiceTypeModel({
    this.serviceTypeId,
    this.name,
    this.description,
    this.price,
    this.durationMinutes,
    this.isActive = true,
  });

  factory ServiceTypeModel.fromJson(Map<String, dynamic> json) {
    return ServiceTypeModel(
      serviceTypeId: json['serviceTypeID'],
      name: json['serviceTypeName'] ?? json['name'],
      description: json['description'],
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
      durationMinutes: json['durationMinutes'] != null ? int.tryParse(json['durationMinutes'].toString()) : null,
      isActive: json['isActive'] == 1 || json['isActive'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceTypeID': serviceTypeId,
      'serviceTypeName': name,
      'description': description,
      'price': price,
      'durationMinutes': durationMinutes,
      'isActive': isActive ? 1 : 0,
    };
  }

  ServiceTypeModel copyWith({
    String? serviceTypeId,
    String? name,
    String? description,
    double? price,
    int? durationMinutes,
    bool? isActive,
  }) {
    return ServiceTypeModel(
      serviceTypeId: serviceTypeId ?? this.serviceTypeId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isActive: isActive ?? this.isActive,
    );
  }
}