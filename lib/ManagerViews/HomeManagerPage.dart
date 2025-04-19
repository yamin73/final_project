import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../Utills/ClientConfig.dart';

class HomeManagerPage extends StatefulWidget {
  const HomeManagerPage({Key? key}) : super(key: key);

  @override
  _HomeManagerPageState createState() => _HomeManagerPageState();
}

class _HomeManagerPageState extends State<HomeManagerPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> todayBookings = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchTodayBookings();
  }

  Future<void> fetchTodayBookings() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Format date as YYYY-MM-DD for API
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      final response = await http.get(
        Uri.parse('${serverPath}bookings/getDailyBookings.php?date=$formattedDate'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          todayBookings = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorSnackBar('Failed to load bookings: Server error');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar('Network error: $e');
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

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2025, 12),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      fetchTodayBookings();
    }
  }

  String _getTimeSlotColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return '#E1F5FE'; // Light Blue
      case 'in progress':
        return '#FFF9C4'; // Light Yellow
      case 'cancelled':
        return '#FFEBEE'; // Light Red
      default:
        return '#E8F5E9'; // Light Green for scheduled
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
            onPressed: () => _selectDate(context),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchTodayBookings,
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
                  DateFormat('EEEE, MMM d, yyyy').format(selectedDate),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.edit_calendar),
                  label: Text('Change Date'),
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Schedule content
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : todayBookings.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No bookings for this day',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: todayBookings.length,
              itemBuilder: (context, index) {
                final booking = todayBookings[index];
                final timeSlot = booking['Time'] ?? 'N/A';
                final customerName = booking['customerName'] ?? 'Unknown';
                final carInfo = '${booking['carBrand'] ?? ''} ${booking['carModel'] ?? ''}';
                final serviceType = booking['serviceType'] ?? 'Service';
                final status = booking['status'] ?? 'Scheduled';

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Colors.blue.shade200,
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            timeSlot.split(' ')[0], // The hour
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            timeSlot.split(' ')[1], // AM/PM
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    title: Text(
                      customerName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(carInfo),
                        SizedBox(height: 4),
                        Text(serviceType),
                      ],
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(int.parse(_getTimeSlotColor(status).substring(1, 7), radix: 16) + 0xFF000000),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      // Show booking details
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => _buildBookingDetails(booking),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new booking manually
          // This would open a form to add booking directly from admin panel
        },
        child: Icon(Icons.add),
        tooltip: 'Add Booking',
      ),
    );
  }

  Widget _buildBookingDetails(Map<String, dynamic> booking) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.only(bottom: 20),
            ),
          ),
          Text(
            'Booking Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          _detailRow('Customer', booking['customerName'] ?? 'Unknown'),
          _detailRow('Phone', booking['customerPhone'] ?? 'N/A'),
          _detailRow('Vehicle', '${booking['carBrand'] ?? ''} ${booking['carModel'] ?? ''} (${booking['year'] ?? ''})'),
          _detailRow('Service', booking['serviceType'] ?? 'Service'),
          _detailRow('Time', booking['Time'] ?? 'N/A'),
          _detailRow('Status', booking['status'] ?? 'Scheduled'),

          if (booking['notes'] != null && booking['notes'].toString().isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  'Notes:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(booking['notes']),
                ),
              ],
            ),

          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.edit),
                label: Text('Edit'),
                onPressed: () {
                  // Navigate to edit booking screen
                  Navigator.pop(context);
                },
              ),
              ElevatedButton.icon(
                icon: Icon(booking['status'] == 'Completed' ? Icons.refresh : Icons.check),
                label: Text(booking['status'] == 'Completed' ? 'Reopen' : 'Mark Completed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: booking['status'] == 'Completed' ? Colors.amber : Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // Update booking status
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}