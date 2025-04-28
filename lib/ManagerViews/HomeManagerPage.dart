import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../Utills/ClientConfig.dart';
import '../ManagerModels/BookingManagerModel.dart';
import '../Utills/ApiService.dart';

class HomeManagerPage extends StatefulWidget {
  const HomeManagerPage({Key? key}) : super(key: key);

  @override
  _HomeManagerPageState createState() => _HomeManagerPageState();
}

class _HomeManagerPageState extends State<HomeManagerPage> {
  bool isLoading = true;
  List<BookingManagerModel> todayBookings = [];
  DateTime selectedDate = DateTime.now();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchDailyBookings();
  }

  Future<void> fetchDailyBookings() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Format date as expected by the API (YYYY-MM-DD)
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      final bookings = await ApiService.getDailyBookings(formattedDate);

      setState(() {
        todayBookings = bookings;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load bookings: $e';
        isLoading = false;
      });
    }
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      fetchDailyBookings();
    }
  }

  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    try {
      final url = Uri.parse('${serverPath}bookings/updateBookingStatus.php');
      final response = await http.post(url, body: {
        'BookingID': bookingId,
        'status': newStatus,
      });

      if (response.statusCode == 200) {
        // Refresh bookings after status update
        fetchDailyBookings();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking status updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to update status');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating booking status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Schedule'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => selectDate(context),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchDailyBookings,
          ),
        ],
      ),
      body: Column(
        children: [
          // Date display
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(selectedDate),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  todayBookings.length.toString() + ' bookings',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Bookings list
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage != null
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: fetchDailyBookings,
                    child: Text('Try Again'),
                  ),
                ],
              ),
            )
                : todayBookings.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No bookings scheduled for this date',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: todayBookings.length,
              itemBuilder: (context, index) {
                final booking = todayBookings[index];
                return BookingCard(
                    booking: booking,
                    onStatusChange: updateBookingStatus
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final BookingManagerModel booking;
  final Function(String, String) onStatusChange;

  const BookingCard({
    Key? key,
    required this.booking,
    required this.onStatusChange,
  }) : super(key: key);

  Color getStatusColor(String? status) {
    switch (status?.toLowerCase() ?? 'scheduled') {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'scheduled':
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time and Status header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: getStatusColor(booking.status).withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: getStatusColor(booking.status),
                    ),
                    SizedBox(width: 8),
                    Text(
                      booking.time ?? 'Time not set',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: getStatusColor(booking.status),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStatusColor(booking.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking.status ?? 'Scheduled',
                    style: TextStyle(
                      color: getStatusColor(booking.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Booking details
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer info
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        booking.customerName?.isNotEmpty == true
                            ? booking.customerName![0].toUpperCase()
                            : '?',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.customerName ?? 'Unknown Customer',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (booking.customerPhone != null)
                            Text(
                              booking.customerPhone!,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.phone, color: Colors.blue),
                      onPressed: () {
                        // Call customer logic
                      },
                    ),
                  ],
                ),
                Divider(),
                // Car and service info
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vehicle',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${booking.year ?? ''} ${booking.carBrand ?? ''} ${booking.carModel ?? ''}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Service',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            booking.serviceType ?? 'Unknown Service',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Notes section if available
                if (booking.notes?.isNotEmpty == true) ...[
                  SizedBox(height: 16),
                  Text(
                    'Notes',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(booking.notes!),
                ],
                // Action buttons
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PopupMenuButton<String>(
                      onSelected: (String value) {
                        onStatusChange(booking.bookingId!, value);
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'Scheduled',
                          child: Text('Mark as Scheduled'),
                        ),
                        PopupMenuItem(
                          value: 'In Progress',
                          child: Text('Mark as In Progress'),
                        ),
                        PopupMenuItem(
                          value: 'Completed',
                          child: Text('Mark as Completed'),
                        ),
                        PopupMenuItem(
                          value: 'Cancelled',
                          child: Text('Mark as Cancelled'),
                        ),
                      ],
                      child: Chip(
                        label: Text('Update Status'),
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}