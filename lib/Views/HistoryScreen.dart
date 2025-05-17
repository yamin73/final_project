import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/booking.dart';
import '../Utills/ClientConfig.dart';
import '../Utills/ApiService.dart';

class BookingHistoryScreen extends StatefulWidget {
  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  String filterStatus = 'All';
  Set<int> expandedItems = {};
  List<Booking> bookings = [];
  bool isLoading = true;
  String? errorMessage;
  String? userID;

  @override
  void initState() {
    super.initState();
    _getUserID();
  }

  Future<void> _getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('token');
    setState(() {
      userID = id;
    });

    if (id != null) {
      fetchBookings(id);
    } else {
      setState(() {
        errorMessage = 'User not logged in. Please log in again.';
        isLoading = false;
      });
    }
  }

  Future<void> fetchBookings(String userID) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final bookingsList = await ApiService.getUserBookings(userID);
      setState(() {
        bookings = bookingsList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load bookings: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'scheduled':
        return Colors.blue;
      case 'today':
        return Colors.orange;
      case 'in progress':
        return Colors.amber;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle_outline;
      case 'scheduled':
        return Icons.event_available;
      case 'today':
        return Icons.today;
      case 'in progress':
        return Icons.directions_car;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }

  List<Booking> getFilteredBookings() {
    if (filterStatus == 'All') {
      return bookings;
    }
    return bookings.where((booking) => booking.status.toLowerCase() == filterStatus.toLowerCase()).toList();
  }

  Widget buildStatusChip(String? status) {
    status = status ?? 'Unknown';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: getStatusColor(status),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(getStatusIcon(status), size: 14, color: getStatusColor(status)),
          SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: getStatusColor(status),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredBookings = getFilteredBookings();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Booking History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
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
                child: Row(
                  children: [
                    Icon(Icons.list, size: 18),
                    SizedBox(width: 8),
                    Text('All Bookings'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Completed',
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Completed'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Scheduled',
                child: Row(
                  children: [
                    Icon(Icons.event_available, size: 18, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Scheduled'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Today',
                child: Row(
                  children: [
                    Icon(Icons.today, size: 18, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Today'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'In Progress',
                child: Row(
                  children: [
                    Icon(Icons.directions_car, size: 18, color: Colors.amber),
                    SizedBox(width: 8),
                    Text('In Progress'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Cancelled',
                child: Row(
                  children: [
                    Icon(Icons.cancel_outlined, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Cancelled'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => userID != null ? fetchBookings(userID!) : _showErrorSnackBar('User not logged in'),
          ),
        ],
      ),
      body: isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading your bookings...',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      )
          : errorMessage != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              SizedBox(height: 16),
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => userID != null ? fetchBookings(userID!) : _showErrorSnackBar('User not logged in'),
                child: Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      )
          : filteredBookings.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: 64,
              color: Colors.blue[300],
            ),
            SizedBox(height: 16),
            Text(
              'No ${filterStatus.toLowerCase() == "all" ? "" : filterStatus.toLowerCase()} bookings found',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: () => userID != null ? fetchBookings(userID!) : Future.error('User not logged in'),
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: filteredBookings.length,
          itemBuilder: (context, index) {
            final booking = filteredBookings[index];
            final isExpanded = expandedItems.contains(int.tryParse(booking.id ?? '0') ?? 0);

            return Card(
              margin: EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          expandedItems.remove(int.tryParse(booking.id ?? '0') ?? 0);
                        } else {
                          expandedItems.add(int.tryParse(booking.id ?? '0') ?? 0);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.directions_car,
                                  color: Colors.blue,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  booking.carDetails ?? 'Vehicle Details Not Available',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              buildStatusChip(booking.status),
                            ],
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(left: 44.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.build, size: 16, color: Colors.grey[600]),
                                    SizedBox(width: 8),
                                    Text(
                                      booking.serviceType,
                                      style: TextStyle(color: Colors.grey[800]),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                                    SizedBox(width: 8),
                                    Text(
                                      booking.formattedDate,
                                      style: TextStyle(color: Colors.grey[800]),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                                    SizedBox(width: 8),
                                    Text(
                                      booking.timeSlot,
                                      style: TextStyle(color: Colors.grey[800]),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      isExpanded ? 'Hide Details' : 'View Details',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(
                                      isExpanded ? Icons.expand_less : Icons.expand_more,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded)
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                      ),
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
                          Container(
                            padding: EdgeInsets.all(12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Text(
                              booking.notes.isNotEmpty ? booking.notes : 'No additional notes.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
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
                                '#${booking.id}',
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
      ),

    );
  }
}