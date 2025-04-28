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

  List<Booking> getFilteredBookings() {
    if (filterStatus == 'All') {
      return bookings;
    }
    return bookings.where((booking) => booking.status.toLowerCase() == filterStatus.toLowerCase()).toList();
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
                value: 'Today',
                child: Text('Today'),
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
            onPressed: () => userID != null ? fetchBookings(userID!) : _showErrorSnackBar('User not logged in'),
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
              onPressed: () => userID != null ? fetchBookings(userID!) : _showErrorSnackBar('User not logged in'),
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
          final isExpanded = expandedItems.contains(int.tryParse(booking.id ?? '0') ?? 0);

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
                    booking.carDetails ?? 'Vehicle Details Not Available',
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
                          Text(booking.serviceType),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            '${booking.formattedDate} at ${booking.timeSlot}',
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildStatusChip(booking.status),
                      IconButton(
                        icon: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isExpanded) {
                              expandedItems.remove(int.tryParse(booking.id ?? '0') ?? 0);
                            } else {
                              expandedItems.add(int.tryParse(booking.id ?? '0') ?? 0);
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
                        Text(booking.notes.isNotEmpty ? booking.notes : 'No additional notes.'),
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
    );
  }
}