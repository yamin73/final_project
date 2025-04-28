import 'package:intl/intl.dart';

class Booking {
  final String? id;
  final String carID;
  final String serviceType;
  final DateTime date;
  final String timeSlot;
  final String status;
  final String notes;
  final String? carDetails;

  Booking({
    this.id,
    required this.carID,
    required this.serviceType,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.notes,
    this.carDetails,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    // Parse the date from the backend format
    DateTime bookingDate;
    try {
      bookingDate = DateTime.parse(json['Date']);
    } catch (e) {
      bookingDate = DateTime.now(); // Fallback
    }

    // Determine booking status if not provided
    String status = json['status'] ?? 'Scheduled';
    if (status.isEmpty) {
      if (bookingDate.isBefore(DateTime.now())) {
        status = 'Completed';
      } else {
        status = 'Scheduled';
      }
    }

    return Booking(
      id: json['BookingID'],
      carID: json['carID'] ?? '',
      serviceType: json['serviceTypeName'] ?? 'Unknown Service',
      date: bookingDate,
      timeSlot: json['Time'] ?? 'N/A',
      status: status,
      notes: json['Note'] ?? '',
      carDetails: json['carDetails'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BookingID': id,
      'carID': carID,
      'serviceTypeName': serviceType,
      'Date': DateFormat('yyyy-MM-dd').format(date),
      'Time': timeSlot,
      'status': status,
      'Note': notes,
      'carDetails': carDetails,
    };
  }

  // Get formatted date for display
  String get formattedDate {
    return DateFormat('MMM d, yyyy').format(date);
  }
}