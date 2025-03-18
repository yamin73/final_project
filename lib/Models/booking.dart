class Booking {
  final int id;
  final String carID;
  final String serviceType;
  final DateTime date;
  final String timeSlot;
  final String status;
  final String notes;

  Booking({
    required this.id,
    required this.carID,
    required this.serviceType,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.notes,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    // Map to store service types based on serviceID
    const Map<String, String> serviceTypes = {
      '1': 'Regular Maintenance',
      '2': 'Full Inspection',
      '3': 'Repair',
      // Add more service types as needed
    };

    // Parse the date from the backend format
    DateTime bookingDate;
    try {
      bookingDate = DateTime.parse(json['Date']);
    } catch (e) {
      bookingDate = DateTime.now(); // Fallback
    }

    // Determine booking status
    String status;
    if (bookingDate.isBefore(DateTime.now())) {
      status = 'Completed';
    } else {
      status = 'Scheduled';
    }

    return Booking(
      id: int.tryParse(json['BookingID']) ?? 0,
      carID: json['carID'] ?? 'Unknown',
      serviceType: serviceTypes[json['serviceID']] ?? 'Unknown Service',
      date: bookingDate,
      timeSlot: json['Time'] ?? 'N/A',
      status: json['Status'] ?? status,
      notes: json['Note'] ?? '',
    );
  }
}