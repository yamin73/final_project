import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../Utills/ClientConfig.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> customersList = [];
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredCustomers = [];
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
        Uri.parse('${serverPath}customers/getAllCustomers.php'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          customersList = List<Map<String, dynamic>>.from(data);
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
        final name = customer['UserName']?.toString().toLowerCase() ?? '';
        final phone = customer['PhoneNumber']?.toString().toLowerCase() ?? '';
        final id = customer['ID']?.toString().toLowerCase() ?? '';
        final email = customer['Email']?.toString().toLowerCase() ?? '';

        return name.contains(query.toLowerCase()) ||
            phone.contains(query.toLowerCase()) ||
            id.contains(query.toLowerCase()) ||
            email.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchCustomers,
          ),
        ],
      ),
      body: Column(
          children: [
      // Search Bar
      Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search by name, phone or ID...',
          prefixIcon: Icon(Icons.search),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
              _filterCustomers('');
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green.shade200),
          ),
          filled: true,
          fillColor: Colors.green.shade50,
        ),
        onChanged: _filterCustomers,
      ),
    ),

    // Customer count
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Row(
    children: [
    Text(
    'Total: ${filteredCustomers.length} customers',
    style: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.grey.shade700,
    ),
    ),
    Spacer(),
    DropdownButton<String>(
    value: 'Name',
    items: ['Name', 'Recent', 'Visits']
        .map((item) => DropdownMenuItem(
    value: item,
    child: Text('Sort by: $item'),
    ))
        .toList(),
    onChanged: (value) {
    // Implement sorting
    },
    ),
    ],
    ),
    ),

    SizedBox(height: 10),

    // Customers List
    Expanded(
    child: isLoading
    ? Center(child: CircularProgressIndicator())
        : filteredCustomers.isEmpty
    ? Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(Icons.people_outline, size: 64, color: Colors.grey),
    SizedBox(height: 16),
    Text(
    isSearching
    ? 'No customers match your search'
        : 'No customers found',
    style: TextStyle(
    fontSize: 18,
    color: Colors.grey,
    ),
    ),
    ],
    ),
    )
        : ListView.builder(
    itemCount: filteredCustomers.length,
    itemBuilder: (context, index) {
    final customer = filteredCustomers[index];
    final name = customer['UserName'] ?? 'Unknown';
    final phone = customer['PhoneNumber'] ?? 'N/A';
    final lastVisit = customer['lastVisit'] != null
    ? DateFormat('MMM d, yyyy').format(DateTime.parse(customer['lastVisit']))
        : 'Never';
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: TextStyle(
              color: Colors.green.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('Phone: $phone'),
            Text('Last Visit: $lastVisit'),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Text(
            customer['visitsCount'] != null ? '${customer['visitsCount']} visits' : 'New',
            style: TextStyle(
              color: Colors.green.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          // Navigate to customer details
          _showCustomerDetails(customer);
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
          // Add new customer
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.person_add),
        tooltip: 'Add Customer',
      ),
    );
  }

  Future<void> _showCustomerDetails(Map<String, dynamic> customer) async {
    // Fetch customer's cars
    List<Map<String, dynamic>> customerCars = [];
    bool isLoadingCars = true;

    try {
      final response = await http.get(
        Uri.parse('${serverPath}cars/getCustomerCars.php?customerID=${customer['clientID']}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        customerCars = List<Map<String, dynamic>>.from(data);
        isLoadingCars = false;
      } else {
        isLoadingCars = false;
      }
    } catch (e) {
      isLoadingCars = false;
    }

    // Fetch customer's service history
    List<Map<String, dynamic>> serviceHistory = [];
    bool isLoadingHistory = true;

    try {
      final response = await http.get(
        Uri.parse('${serverPath}bookings/getCustomerBookings.php?customerID=${customer['clientID']}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        serviceHistory = List<Map<String, dynamic>>.from(data);
        isLoadingHistory = false;
      } else {
        isLoadingHistory = false;
      }
    } catch (e) {
      isLoadingHistory = false;
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Customer Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.edit),
                    label: Text('Edit'),
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to edit customer page
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Customer Info Card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.green.shade100,
                            child: Text(
                              customer['UserName'] != null && customer['UserName'].toString().isNotEmpty
                                  ? customer['UserName'][0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customer['UserName'] ?? 'Unknown',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.phone, size: 16, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text(customer['PhoneNumber'] ?? 'N/A'),
                                  ],
                                ),
                                if (customer['Email'] != null)
                                  Row(
                                    children: [
                                      Icon(Icons.email, size: 16, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Text(customer['Email']),
                                    ],
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Divider(height: 30),
                      _detailRow('Customer ID', customer['clientID'] ?? 'N/A'),
                      _detailRow('ID Number', customer['ID'] ?? 'N/A'),
                      _detailRow('Joined', customer['createdDateTime'] != null
                          ? DateFormat('MMM d, yyyy').format(DateTime.parse(customer['createdDateTime']))
                          : 'N/A'),
                      _detailRow('Total Visits', customer['visitsCount'] != null ? '${customer['visitsCount']}' : '0'),
                      _detailRow('Last Visit', customer['lastVisit'] != null
                          ? DateFormat('MMM d, yyyy').format(DateTime.parse(customer['lastVisit']))
                          : 'Never'),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Customer's Cars Section
              Text(
                'Customer\'s Cars',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              isLoadingCars
                  ? Center(child: CircularProgressIndicator())
                  : customerCars.isEmpty
                  ? Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('No cars registered for this customer'),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: customerCars.length,
                itemBuilder: (context, index) {
                  final car = customerCars[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Icon(Icons.directions_car, color: Colors.blue),
                      title: Text('${car['carBrand'] ?? ''} ${car['carModel'] ?? ''}'),
                      subtitle: Text('License: ${car['carLicense'] ?? 'N/A'}'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Show car details
                      },
                    ),
                  );
                },
              ),

              SizedBox(height: 20),

              // Service History Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Service History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // View full history in separate screen
                    },
                    child: Text('View All'),
                  ),
                ],
              ),
              SizedBox(height: 10),

              isLoadingHistory
                  ? Center(child: CircularProgressIndicator())
                  : serviceHistory.isEmpty
                  ? Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('No service history for this customer'),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: serviceHistory.length > 3 ? 3 : serviceHistory.length,
                itemBuilder: (context, index) {
                  final service = serviceHistory[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.build, color: Colors.amber.shade800),
                      ),
                      title: Text(service['serviceType'] ?? 'Service'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Car: ${service['carBrand'] ?? ''} ${service['carModel'] ?? ''}'),
                          Text('Date: ${service['Date'] != null ? DateFormat('MMM d, yyyy').format(DateTime.parse(service['Date'])) : 'N/A'}'),
                        ],
                      ),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: service['status'] == 'Completed' ? Colors.green.shade100 : Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          service['status'] ?? 'Pending',
                          style: TextStyle(
                            color: service['status'] == 'Completed' ? Colors.green.shade800 : Colors.blue.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        // Show service details
                      },
                    ),
                  );
                },
              ),

              SizedBox(height: 30),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.add_circle_outline),
                    label: Text('New Car'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(140, 50),
                    ),
                    onPressed: () {
                      // Add new car for this customer
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.calendar_today),
                    label: Text('New Booking'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: Size(140, 50),
                    ),
                    onPressed: () {
                      // Create new booking for this customer
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
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