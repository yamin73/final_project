import 'package:intl/intl.dart';

class BookingManagerModel {
  final String? bookingId;
  final String? carId;
  final String? carBrand;
  final String? carModel;
  final String? year;
  final String? customerName;
  final String? customerPhone;
  final String? serviceType;
  final String? serviceTypeId;
  final DateTime? date;
  final String? time;
  final String? status;
  final String? notes;

  BookingManagerModel({
    this.bookingId,
    this.carId,
    this.carBrand,
    this.carModel,
    this.year,
    this.customerName,
    this.customerPhone,
    this.serviceType,
    this.serviceTypeId,
    this.date,
    this.time,
    this.status,
    this.notes,
  });

  factory BookingManagerModel.fromJson(Map<String, dynamic> json) {
    // Parse the date from the backend format
    DateTime? bookingDate;
    try {
      if (json['Date'] != null) {
        bookingDate = DateTime.parse(json['Date'].toString());
      }
    } catch (e) {
      bookingDate = null;
    }

    // Determine booking status if not provided
    String status = json['status']?.toString() ?? 'Scheduled';
    if (status.isEmpty && bookingDate != null) {
      if (bookingDate.isBefore(DateTime.now())) {
        status = 'Completed';
      } else {
        status = 'Scheduled';
      }
    }

    // Convert all ID fields to strings
    return BookingManagerModel(
      bookingId: json['BookingID']?.toString(),
      carId: json['carID']?.toString(),
      carBrand: json['carBrand']?.toString(),
      carModel: json['carModel']?.toString(),
      year: json['year']?.toString(),
      customerName: json['customerName']?.toString(),
      customerPhone: json['customerPhone']?.toString(),
      serviceType: json['serviceType']?.toString(),
      serviceTypeId: json['serviceTypeID']?.toString(),
      date: bookingDate,
      time: json['Time']?.toString(),
      status: status,
      notes: json['Note']?.toString() ?? json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BookingID': bookingId,
      'carID': carId,
      'carBrand': carBrand,
      'carModel': carModel,
      'year': year,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'serviceType': serviceType,
      'serviceTypeID': serviceTypeId,
      'Date': date != null ? DateFormat('yyyy-MM-dd').format(date!) : null,
      'Time': time,
      'status': status,
      'Note': notes,
    };
  }

  // Get formatted date for display
  String get formattedDate {
    if (date == null) return 'Not scheduled';
    return DateFormat('MMM d, yyyy').format(date!);
  }
}