import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../Utills/ClientConfig.dart';
import '../ManagerModels/BookingManagerModel.dart';

class HomeManagerPage extends StatefulWidget {
  const HomeManagerPage({Key? key}) : super(key: key);

  @override
  _HomeManagerPageState createState() => _HomeManagerPageState();
}

class _HomeManagerPageState extends State<HomeManagerPage> {
  bool isLoading = true;
  List<BookingManagerModel> todayBookings = [];
  DateTime selectedDate = DateTime.now(); // Default to today's date
  String? errorMessage;
  int totalBookings = 0;
  int completedBookings = 0;
  int pendingBookings = 0;

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
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      print("⏳ Fetching bookings for date: $formattedDate");

      // Call the PHP endpoint to get daily bookings
      final url = Uri.parse('${serverPath}bookings/getDailyBookings.php?date=$formattedDate');
      print("🌐 Making request to URL: $url");

      final response = await http.get(url);
      print("📥 Response status code: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      if (response.statusCode == 200) {
        // Check if response is empty
        if (response.body.isEmpty) {
          print("⚠️ Empty response body");
          setState(() {
            todayBookings = [];
            totalBookings = 0;
            completedBookings = 0;
            pendingBookings = 0;
            isLoading = false;
          });
          return;
        }

        // Parse the JSON response
        try {
          print("🔄 Attempting to parse JSON...");
          final List<dynamic> decodedData = json.decode(response.body);
          print("✅ JSON parsed successfully");
          print("📊 Data type: ${decodedData.runtimeType}");
          print("📋 Found ${decodedData.length} bookings in response");

          // Convert each JSON object to a BookingManagerModel
          List<BookingManagerModel> fetchedBookings = [];
          for (var item in decodedData) {
            print("🔄 Processing booking item: $item");
            try {
              BookingManagerModel booking = BookingManagerModel.fromJson(item);
              print("✅ Successfully created booking object");
              fetchedBookings.add(booking);
            } catch (e) {
              print("❌ Error creating booking from JSON: $e");
              print("❌ Problematic JSON: $item");
            }
          }

          setState(() {
            todayBookings = fetchedBookings;

            // Calculate stats
            totalBookings = fetchedBookings.length;
            completedBookings = fetchedBookings.where((booking) =>
            (booking.status?.toLowerCase() ?? '') == 'completed').length;
            pendingBookings = fetchedBookings.where((booking) =>
            (booking.status?.toLowerCase() ?? '') == 'scheduled' ||
                (booking.status?.toLowerCase() ?? '') == 'in progress').length;

            isLoading = false;
          });
          print("🎉 UI updated with ${fetchedBookings.length} bookings");
        } catch (e) {
          print("❌ JSON parsing error: $e");
          throw Exception('Failed to parse response: $e');
        }
      } else {
        print("❌ HTTP error: ${response.statusCode}");
        throw Exception('Failed to load bookings: Server error ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Overall fetch error: $e");
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
    bool isToday = DateUtils.isSameDay(selectedDate, DateTime.now());

    return Scaffold(
      body: Column(
        children: [
          // Date selection and summary bar
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          isToday ? 'Today' : DateFormat('EEE, MMM d').format(selectedDate),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '(${DateFormat('yyyy').format(selectedDate)})',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
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
                  ],
                ),

                // Stats cards row
                if (!isLoading && errorMessage == null)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        _buildStatCard('Total', totalBookings, Colors.blue),
                        SizedBox(width: 8),
                        _buildStatCard('Completed', completedBookings, Colors.green),
                        SizedBox(width: 8),
                        _buildStatCard('Pending', pendingBookings, Colors.orange),
                      ],
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
                  if (isToday)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'The schedule is clear today',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new booking functionality
          // You can implement this in the future
        },
        child: Icon(Icons.add),
        tooltip: 'Add new booking',
      ),
    );
  }

  Widget _buildStatCard(String title, int count, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
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
                    OutlinedButton.icon(
                      icon: Icon(Icons.info_outline),
                      label: Text('Details'),
                      onPressed: () {
                        // Show detailed booking info
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                    ),
                    SizedBox(width: 8),
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
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Update Status'),
                            Icon(Icons.arrow_drop_down, size: 16),
                          ],
                        ),
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