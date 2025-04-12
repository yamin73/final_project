import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Utills/ClientConfig.dart';

class BookingHistoryScreen extends StatefulWidget {
  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  String filterStatus = 'All';
  Set<int> expandedItems = {};
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;
  String? errorMessage;

  // Map to store service types based on serviceID
  final Map<String, String> serviceTypes = {
    '1': 'Regular Maintenance',
    '2': 'Full Inspection',
    '3': 'Repair',
    // Add more service types as needed
  };

  // Map to track booking statuses - this would be from your backend
  // You might need to adjust this based on your actual data structure
  final Map<int, String> bookingStatuses = {};

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse(serverPath + 'bookings/getBooking.php'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        setState(() {
          bookings = jsonData.map((data) {
            // Parse the date from the backend format
            DateTime? bookingDate;
            try {
              bookingDate = DateTime.parse(data['Date']);
            } catch (e) {
              bookingDate = DateTime.now(); // Fallback
            }

            // Assign a default status if not provided by backend
            // You might want to determine this based on date or other factors
            int bookingId = int.tryParse(data['BookingID']) ?? 0;
            if (!bookingStatuses.containsKey(bookingId)) {
              if (bookingDate.isBefore(DateTime.now())) {
                bookingStatuses[bookingId] = 'Completed';
              } else {
                bookingStatuses[bookingId] = 'Scheduled';
              }
            }

            int carID = int.tryParse(data['carID']) ?? 0;

            return {
              'id': bookingId,
              'carID': carID,
              'serviceType': serviceTypes[data['serviceTypeID']] ?? 'Unknown Service',
              'date': bookingDate,
              'timeSlot': data['Time'],
              'status': bookingStatuses[bookingId],
              'notes': data['Note'] ?? '',

            };
          }).toList().cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load bookings. Server error ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load bookings: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'scheduled':
        return Colors.blue;
      case 'in progress':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  List<Map<String, dynamic>> getFilteredBookings() {
    if (filterStatus == 'All') {
      return bookings;
    }
    return bookings.where((booking) => booking['status'] == filterStatus).toList();
  }

  Widget buildStatusChip(String? status) {
    status = status ?? 'Unknown';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: getStatusColor(status),
          width: 1,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: getStatusColor(status),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredBookings = getFilteredBookings();

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking History'),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list),
            onSelected: (String value) {
              setState(() {
                filterStatus = value;
              });
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'All',
                child: Text('All Bookings'),
              ),
              PopupMenuItem(
                value: 'Completed',
                child: Text('Completed'),
              ),
              PopupMenuItem(
                value: 'Scheduled',
                child: Text('Scheduled'),
              ),
              PopupMenuItem(
                value: 'In Progress',
                child: Text('In Progress'),
              ),
              PopupMenuItem(
                value: 'Cancelled',
                child: Text('Cancelled'),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchBookings,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage!,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchBookings,
              child: Text('Try Again'),
            ),
          ],
        ),
      )
          : filteredBookings.isEmpty
          ? Center(child: Text('No bookings found'))
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: filteredBookings.length,
        itemBuilder: (context, index) {
          final booking = filteredBookings[index];
          final isExpanded = expandedItems.contains(booking['id']);

          return Card(
            margin: EdgeInsets.only(bottom: 16),
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: Icon(
                      Icons.directions_car,
                      color: Colors.blue,
                    ),
                  ),
                  title: Text(
                    '${booking['carBrand']} ${booking['carModel']} ${booking['year']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.build, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(booking['serviceType']),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            '${DateFormat('MMM dd, yyyy').format(booking['date'])} at ${booking['timeSlot']}',
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildStatusChip(booking['status']),
                      IconButton(
                        icon: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isExpanded) {
                              expandedItems.remove(booking['id']);
                            } else {
                              expandedItems.add(booking['id']);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                if (isExpanded)
                  Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.grey[50],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Service Details',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(booking['notes'] ?? 'No additional notes.'),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Booking ID',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '#${booking['id']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
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
        },
      ),
    );
  }
}