import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingHistoryScreen extends StatefulWidget {
  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  String filterStatus = 'All';
  Set<int> expandedItems = {};

  // Sample booking data - In a real app, this would come from a database or API
  final List<Map<String, dynamic>> bookings = [
    {
      'id': 1,
      'carBrand': 'Toyota',
      'carModel': 'Camry',
      'year': '2020',
      'serviceType': 'Regular Maintenance',
      'date': DateTime.now().subtract(Duration(days: 5)),
      'timeSlot': '10:00 AM',
      'status': 'Completed',
      'notes': 'Oil change and filter replacement',
      'cost': '\$150'
    },
    {
      'id': 2,
      'carBrand': 'Honda',
      'carModel': 'Civic',
      'year': '2019',
      'serviceType': 'Full Inspection',
      'date': DateTime.now().add(Duration(days: 2)),
      'timeSlot': '2:00 PM',
      'status': 'Scheduled',
      'notes': 'Annual inspection',
      'cost': '\$200'
    },
    {
      'id': 3,
      'carBrand': 'BMW',
      'carModel': '3 Series',
      'year': '2021',
      'serviceType': 'Repair',
      'date': DateTime.now().subtract(Duration(days: 1)),
      'timeSlot': '11:30 AM',
      'status': 'In Progress',
      'notes': 'Brake system maintenance',
      'cost': '\$350'
    },
  ];

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

  Widget buildStatusChip(String status) {
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
        ],
      ),
      body: ListView.builder(
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
                        Text(booking['notes']),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cost',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              booking['cost'],
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