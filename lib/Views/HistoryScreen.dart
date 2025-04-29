// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../Models/booking.dart';
// import '../Utills/ClientConfig.dart';
// import '../Utills/ApiService.dart';
//
// class BookingHistoryScreen extends StatefulWidget {
//   @override
//   _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
// }
//
// class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
//   String filterStatus = 'All';
//   Set<int> expandedItems = {};
//   List<Booking> bookings = [];
//   bool isLoading = true;
//   String? errorMessage;
//   String? userID;
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserID();
//   }
//
//   Future<void> _getUserID() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? id = prefs.getString('token');
//     setState(() {
//       userID = id;
//     });
//
//     if (id != null) {
//       fetchBookings(id);
//     } else {
//       setState(() {
//         errorMessage = 'User not logged in. Please log in again.';
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> fetchBookings(String userID) async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });
//
//     try {
//       final bookingsList = await ApiService.getUserBookings(userID);
//       setState(() {
//         bookings = bookingsList;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Failed to load bookings: ${e.toString()}';
//         isLoading = false;
//       });
//     }
//   }
//
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }
//
//   Color getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'completed':
//         return Colors.green;
//       case 'scheduled':
//         return Colors.blue;
//       case 'today':
//         return Colors.orange;
//       case 'in progress':
//         return Colors.amber;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   List<Booking> getFilteredBookings() {
//     if (filterStatus == 'All') {
//       return bookings;
//     }
//     return bookings.where((booking) => booking.status.toLowerCase() == filterStatus.toLowerCase()).toList();
//   }
//
//   Widget buildStatusChip(String? status) {
//     status = status ?? 'Unknown';
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: getStatusColor(status).withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: getStatusColor(status),
//           width: 1,
//         ),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(
//           color: getStatusColor(status),
//           fontWeight: FontWeight.bold,
//           fontSize: 12,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final filteredBookings = getFilteredBookings();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Booking History'),
//         actions: [
//           PopupMenuButton<String>(
//             icon: Icon(Icons.filter_list),
//             onSelected: (String value) {
//               setState(() {
//                 filterStatus = value;
//               });
//             },
//             itemBuilder: (BuildContext context) => [
//               PopupMenuItem(
//                 value: 'All',
//                 child: Text('All Bookings'),
//               ),
//               PopupMenuItem(
//                 value: 'Completed',
//                 child: Text('Completed'),
//               ),
//               PopupMenuItem(
//                 value: 'Scheduled',
//                 child: Text('Scheduled'),
//               ),
//               PopupMenuItem(
//                 value: 'Today',
//                 child: Text('Today'),
//               ),
//               PopupMenuItem(
//                 value: 'In Progress',
//                 child: Text('In Progress'),
//               ),
//               PopupMenuItem(
//                 value: 'Cancelled',
//                 child: Text('Cancelled'),
//               ),
//             ],
//           ),
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () => userID != null ? fetchBookings(userID!) : _showErrorSnackBar('User not logged in'),
//           ),
//         ],
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : errorMessage != null
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               errorMessage!,
//               style: TextStyle(color: Colors.red),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () => userID != null ? fetchBookings(userID!) : _showErrorSnackBar('User not logged in'),
//               child: Text('Try Again'),
//             ),
//           ],
//         ),
//       )
//           : filteredBookings.isEmpty
//           ? Center(child: Text('No bookings found'))
//           : ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: filteredBookings.length,
//         itemBuilder: (context, index) {
//           final booking = filteredBookings[index];
//           final isExpanded = expandedItems.contains(int.tryParse(booking.id ?? '0') ?? 0);
//
//           return Card(
//             margin: EdgeInsets.only(bottom: 16),
//             elevation: 2,
//             child: Column(
//               children: [
//                 ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: Colors.blue.withOpacity(0.1),
//                     child: Icon(
//                       Icons.directions_car,
//                       color: Colors.blue,
//                     ),
//                   ),
//                   title: Text(
//                     booking.carDetails ?? 'Vehicle Details Not Available',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Icon(Icons.build, size: 16, color: Colors.grey),
//                           SizedBox(width: 4),
//                           Text(booking.serviceType),
//                         ],
//                       ),
//                       SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Icon(Icons.access_time, size: 16, color: Colors.grey),
//                           SizedBox(width: 4),
//                           Text(
//                             '${booking.formattedDate} at ${booking.timeSlot}',
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       buildStatusChip(booking.status),
//                       IconButton(
//                         icon: Icon(
//                           isExpanded ? Icons.expand_less : Icons.expand_more,
//                           color: Colors.grey,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             if (isExpanded) {
//                               expandedItems.remove(int.tryParse(booking.id ?? '0') ?? 0);
//                             } else {
//                               expandedItems.add(int.tryParse(booking.id ?? '0') ?? 0);
//                             }
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (isExpanded)
//                   Container(
//                     padding: EdgeInsets.all(16),
//                     color: Colors.grey[50],
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Service Details',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text(booking.notes.isNotEmpty ? booking.notes : 'No additional notes.'),
//                         SizedBox(height: 16),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Booking ID',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             Text(
//                               '#${booking.id}',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.blue,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
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
  }

  static Future<List<Booking>> getBookingHistory(String userID) async {
    try {
      final url = Uri.parse('${serverPath}bookings/getUserBookings.php?userID=$userID');
      print("Fetching bookings from URL: $url");

      final response = await http.get(url);
      print("Response status code: ${response.statusCode}");
      print("Response body length: ${response.body.length}");
      print("Response body: ${response.body}"); // Print full response for debugging

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        print("JSON data type: ${jsonData.runtimeType}");

        if (jsonData is Map && jsonData.containsKey('result') && jsonData['result'] == '0') {
          throw Exception(jsonData['message'] ?? 'Failed to load bookings');
        }

        List<Booking> bookings = [];
        if (jsonData is List) {
          print("Found ${jsonData.length} bookings in response");
          for (var item in jsonData) {
            try {
              Booking booking = Booking.fromJson(item);
              print("Successfully parsed booking: ID=${booking.id}, Service=${booking.serviceType}");
              bookings.add(booking);
            } catch (e) {
              print("Error parsing booking: $e");
              print("Problematic JSON: $item");
            }
          }

          print("Final bookings list size: ${bookings.length}");
        } else {
          print("JSON data is not a list: $jsonData");
        }

        return bookings;
      } else {
        print("Error response: ${response.body}");
        throw Exception('Failed to load bookings. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bookings: $e');
      throw Exception('Error fetching bookings: $e');
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
            onPressed: () => setState(() {}), // This will refresh the FutureBuilder
          ),
        ],
      ),
      body: FutureBuilder<List<Booking>>(
        future: getBookingHistory(userID!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot.error.toString(),
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}), // This will retry the future
                    child: Text('Try Again'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 2,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'No bookings found',
                  style: TextStyle(fontSize: 23, color: Colors.black),
                ),
              ),
            );
          } else {
            // We have data to display
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final booking = snapshot.data![index];

                      return Card(
                        margin: EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              int bookingId = int.tryParse(booking.id ?? '0') ?? 0;
                              if (expandedItems.contains(bookingId)) {
                                expandedItems.remove(bookingId);
                              } else {
                                expandedItems.add(bookingId);
                              }
                            });
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            child: Icon(
                              Icons.directions_car,
                              color: Colors.blue,
                            ),
                          ),
                          title: Text(
                            booking.carDetails ?? 'Vehicle Details Not Available',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
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
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                              if (expandedItems.contains(int.tryParse(booking.id ?? '0') ?? 0))
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
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
                                      SizedBox(height: 4),
                                      Text(booking.notes.isNotEmpty ? booking.notes : 'No additional notes.'),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Booking ID',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            '#${booking.id}',
                                            style: TextStyle(
                                              fontSize: 14,
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
                          trailing: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: buildStatusChip(booking.status),
                          ),
                          isThreeLine: expandedItems.contains(int.tryParse(booking.id ?? '0') ?? 0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}