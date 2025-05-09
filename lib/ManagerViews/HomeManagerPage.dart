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
      body: RefreshIndicator(
        onRefresh: fetchDailyBookings,
        child: Column(
          children: [
            // Date selector and stats
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date picker row
                  InkWell(
                    onTap: () => selectDate(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 8),
                          Text(
                            isToday
                                ? 'Today, ${DateFormat('d MMM').format(selectedDate)}'
                                : DateFormat('EEE, d MMM').format(selectedDate),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Stats cards
                  if (!isLoading && errorMessage == null)
                    Row(
                      children: [
                        _buildStatCard(
                          'Total',
                          totalBookings,
                          Icons.calendar_today,
                          Theme.of(context).primaryColor,
                        ),
                        SizedBox(width: 8),
                        _buildStatCard(
                          'Completed',
                          completedBookings,
                          Icons.check_circle_outline,
                          Colors.green,
                        ),
                        SizedBox(width: 8),
                        _buildStatCard(
                          'Pending',
                          pendingBookings,
                          Icons.schedule,
                          Colors.orange,
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Timeline view header
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    'Schedule Timeline',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  if (todayBookings.isNotEmpty)
                    OutlinedButton.icon(
                      icon: Icon(Icons.sort, size: 18),
                      label: Text(
                        'Sort',
                        style: TextStyle(fontSize: 13),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        minimumSize: Size(0, 36),
                      ),
                      onPressed: () {
                        // Show sort options
                        _showSortOptions(context);
                      },
                    ),
                ],
              ),
            ),

            // Bookings list
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage != null
                  ? _buildErrorView()
                  : todayBookings.isEmpty
                  ? _buildEmptyView(isToday)
                  : ListView.builder(
                itemCount: todayBookings.length,
                itemBuilder: (context, index) {
                  final booking = todayBookings[index];
                  return BookingTimelineItem(
                    booking: booking,
                    onStatusChange: updateBookingStatus,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
            SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              errorMessage ?? 'Failed to load bookings',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: fetchDailyBookings,
              icon: Icon(Icons.refresh),
              label: Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(bool isToday) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 64,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          Text(
            'No bookings scheduled',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            isToday
                ? 'Your schedule is clear for today'
                : 'No appointments for this date',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Show add booking dialog
            },
            icon: Icon(Icons.add),
            label: Text('Add Booking'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Sort Bookings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text('By Time (Earliest First)'),
              onTap: () {
                Navigator.pop(context);
                // Implement sorting
                setState(() {
                  todayBookings.sort((a, b) => (a.time ?? '').compareTo(b.time ?? ''));
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text('By Status'),
              onTap: () {
                Navigator.pop(context);
                // Implement sorting
                setState(() {
                  todayBookings.sort((a, b) {
                    // Define status priority: In Progress > Scheduled > Completed > Cancelled
                    Map<String, int> statusPriority = {
                      'in progress': 0,
                      'scheduled': 1,
                      'completed': 2,
                      'cancelled': 3,
                    };

                    int aPriority = statusPriority[a.status?.toLowerCase() ?? ''] ?? 1;
                    int bPriority = statusPriority[b.status?.toLowerCase() ?? ''] ?? 1;

                    return aPriority.compareTo(bPriority);
                  });
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Recently Updated'),
              onTap: () {
                Navigator.pop(context);
                // This would typically be implemented with a last updated timestamp
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    );
  }
}

class BookingTimelineItem extends StatelessWidget {
  final BookingManagerModel booking;
  final Function(String, String) onStatusChange;

  const BookingTimelineItem({
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
    return InkWell(
      onTap: () {
        _showBookingDetails(context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time column
            SizedBox(
              width: 50,
              child: Column(
                children: [
                  Text(
                    booking.time != null
                        ? booking.time!.substring(0, 5) // Display HH:MM
                        : '--:--',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    booking.time != null
                        ? booking.time!.contains('AM') ? 'AM' : 'PM'
                        : '',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Timeline vertical line with dot
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 8),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: getStatusColor(booking.status),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 2,
                  height: 100, // Set height based on content
                  color: Colors.grey.shade300,
                ),
              ],
            ),
            SizedBox(width: 12),

            // Booking card
            Expanded(
              child: Card(
                elevation: 1,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: getStatusColor(booking.status).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '${booking.customerName ?? 'Unknown Customer'}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: getStatusColor(booking.status).withOpacity(0.1),
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

                      SizedBox(height: 8),

                      // Vehicle info
                      Row(
                        children: [
                          Icon(Icons.directions_car, size: 14, color: Colors.grey),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${booking.year ?? ''} ${booking.carBrand ?? ''} ${booking.carModel ?? ''}',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 4),

                      // Service info
                      Row(
                        children: [
                          Icon(Icons.build, size: 14, color: Colors.grey),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              booking.serviceType ?? 'Unknown Service',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      // Bottom action row
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Call button
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: Icon(Icons.phone, size: 20, color: Colors.blue),
                            onPressed: () {
                              // Call customer
                            },
                          ),

                          // Status update button
                          if (booking.status?.toLowerCase() != 'completed' &&
                              booking.status?.toLowerCase() != 'cancelled')
                            TextButton.icon(
                              icon: Icon(Icons.check, size: 18),
                              label: Text(
                                booking.status?.toLowerCase() == 'scheduled'
                                    ? 'Start'
                                    : 'Complete',
                                style: TextStyle(fontSize: 13),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                minimumSize: Size(0, 36),
                              ),
                              onPressed: () {
                                String newStatus = booking.status?.toLowerCase() == 'scheduled'
                                    ? 'In Progress'
                                    : 'Completed';
                                onStatusChange(booking.bookingId!, newStatus);
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: controller,
            padding: EdgeInsets.all(16),
            children: [
              // Sheet handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              // Booking header with status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: getStatusColor(booking.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      booking.status ?? 'Scheduled',
                      style: TextStyle(
                        color: getStatusColor(booking.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Time info
              _buildDetailSection(
                'Appointment',
                [
                  _buildDetailRow(
                    Icons.access_time,
                    'Time',
                    booking.time ?? 'Not specified',
                  ),
                  SizedBox(height: 12),
                  _buildDetailRow(
                    Icons.event_note,
                    'Reference',
                    '#${booking.bookingId ?? 'Unknown'}',
                  ),
                ],
              ),

              Divider(height: 32),

              // Customer info
              _buildDetailSection(
                'Customer',
                [
                  _buildDetailRow(
                    Icons.person,
                    'Name',
                    booking.customerName ?? 'Unknown Customer',
                  ),
                  if (booking.customerPhone != null) ...[
                    SizedBox(height: 12),
                    _buildDetailRow(
                      Icons.phone,
                      'Phone',
                      booking.customerPhone!,
                      actionIcon: Icons.phone,
                      onAction: () {
                        // Call customer
                      },
                    ),
                  ],
                ],
              ),

              Divider(height: 32),

              // Vehicle info
              _buildDetailSection(
                'Vehicle',
                [
                  _buildDetailRow(
                    Icons.directions_car,
                    'Model',
                    '${booking.year ?? ''} ${booking.carBrand ?? ''} ${booking.carModel ?? ''}',
                  ),
                  SizedBox(height: 12),
                  _buildDetailRow(
                    Icons.build,
                    'Service',
                    booking.serviceType ?? 'Unknown Service',
                  ),
                ],
              ),

              // Notes section if available
              if (booking.notes?.isNotEmpty == true) ...[
                Divider(height: 32),
                _buildDetailSection(
                  'Notes',
                  [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(booking.notes!),
                    ),
                  ],
                ),
              ],

              SizedBox(height: 32),

              // Action buttons
              if (booking.status?.toLowerCase() != 'completed' &&
                  booking.status?.toLowerCase() != 'cancelled')
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.close),
                        label: Text('Cancel Booking'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          foregroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onStatusChange(booking.bookingId!, 'Cancelled');
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(
                          booking.status?.toLowerCase() == 'scheduled'
                              ? Icons.play_arrow
                              : Icons.check,
                        ),
                        label: Text(
                          booking.status?.toLowerCase() == 'scheduled'
                              ? 'Start Service'
                              : 'Complete Service',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: getStatusColor(booking.status),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          String newStatus = booking.status?.toLowerCase() == 'scheduled'
                              ? 'In Progress'
                              : 'Completed';
                          onStatusChange(booking.bookingId!, newStatus);
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(
      IconData icon,
      String label,
      String value, {
        IconData? actionIcon,
        VoidCallback? onAction,
      }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: Colors.grey.shade700),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (actionIcon != null && onAction != null)
          IconButton(
            icon: Icon(actionIcon, color: Colors.blue),
            onPressed: onAction,
          ),
      ],
    );
  }
}