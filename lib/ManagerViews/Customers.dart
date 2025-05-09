import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../Utills/ClientConfig.dart';
import '../ManagerModels/CustomerManagerModel.dart';
import '../ManagerModels/CarHistoryModel.dart';
import '../ManagerModels/BookingManagerModel.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  bool isLoading = true;
  List<CustomerManagerModel> customersList = [];
  List<CustomerManagerModel> filteredCustomers = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchCustomers() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('${serverPath}users/getAllCustomers.php'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          customersList = data.map((item) => CustomerManagerModel.fromJson(item)).toList();
          filteredCustomers = customersList;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorSnackBar('Failed to load customers: Server error');
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

  void _filterCustomers(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredCustomers = customersList;
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
      filteredCustomers = customersList.where((customer) {
        final userName = customer.userName?.toLowerCase() ?? '';
        final phoneNumber = customer.phoneNumber?.toLowerCase() ?? '';
        final email = customer.email?.toLowerCase() ?? '';

        return userName.contains(query.toLowerCase()) ||
            phoneNumber.contains(query.toLowerCase()) ||
            email.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search customers...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterCustomers,
            ),
          ),
          Expanded(
            child: filteredCustomers.isEmpty
                ? Center(
              child: Text(
                isSearching ? 'No matching customers found' : 'No customers data available',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = filteredCustomers[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: Icon(Icons.person, color: Colors.blue),
                    ),
                    title: Text(
                      customer.userName ?? 'Unknown',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text('Phone: ${customer.phoneNumber ?? 'N/A'}'),
                        if (customer.email != null && customer.email!.isNotEmpty)
                          Text('Email: ${customer.email}'),
                        Text('Last Visit: ${customer.lastVisit ?? 'N/A'}'),
                        Text('Visits: ${customer.visitsCount ?? 0}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        // Show customer options menu
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Edit Customer'),
                                onTap: () {
                                  Navigator.pop(context);
                                  // Navigate to edit customer screen
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.directions_car),
                                title: Text('View Cars'),
                                onTap: () {
                                  Navigator.pop(context);
                                  // Navigate to customer cars screen
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.history),
                                title: Text('Booking History'),
                                onTap: () {
                                  Navigator.pop(context);
                                  // Navigate to customer booking history
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new customer functionality
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}