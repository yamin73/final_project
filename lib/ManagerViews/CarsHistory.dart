import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../Utills/ClientConfig.dart';

class CarsHistory extends StatefulWidget {
  const CarsHistory({Key? key}) : super(key: key);

  @override
  _CarsHistoryState createState() => _CarsHistoryState();
}

class _CarsHistoryState extends State<CarsHistory> {
  bool isLoading = true;
  List<Map<String, dynamic>> carsList = [];
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredCars = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchCarsHistory();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchCarsHistory() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('${serverPath}cars/getAllCarsHistory.php'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          carsList = List<Map<String, dynamic>>.from(data);
          filteredCars = carsList;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorSnackBar('Failed to load cars history: Server error');
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

  void _filterCars(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredCars = carsList;
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
      filteredCars = carsList.where((car) {
        final carBrand = car['carBrand']?.toString().toLowerCase() ?? '';
        final carModel = car['carModel']?.toString().toLowerCase() ?? '';
        final carLicense = car['carLicense']?.toString().toLowerCase() ?? '';
        final ownerName = car['ownerName']?.toString().toLowerCase() ?? '';

        return carBrand.contains(query.toLowerCase()) ||
            carModel.contains(query.toLowerCase()) ||
            carLicense.contains(query.toLowerCase()) ||
            ownerName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cars History'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchCarsHistory,
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
                hintText: 'Search by brand, model, license or owner...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    _filterCars('');
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue.shade200),
                ),
                filled: true,
                fillColor: Colors.blue.shade50,
              ),
              onChanged: _filterCars,
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('All', isSearching ? false : true),
                _buildFilterChip('Toyota', false),
                _buildFilterChip('BMW', false),
                _buildFilterChip('Mercedes', false),
                _buildFilterChip('Honda', false),
                _buildFilterChip('Audi', false),
                _buildFilterChip('Volkswagen', false),
              ],
            ),
          ),

          SizedBox(height: 10),

          // Cars List
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredCars.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_car_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    isSearching
                        ? 'No cars match your search'
                        : 'No cars in the history',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: filteredCars.length,
              itemBuilder: (context, index) {
                final car = filteredCars[index];
                final carInfo = '${car['carBrand'] ?? ''} ${car['carModel'] ?? ''}';
                final lastVisit = car['lastVisit'] != null
                    ? DateFormat('MMM d, yyyy').format(DateTime.parse(car['lastVisit']))
                    : 'N/A';

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(
                        Icons.directions_car,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    title: Text(
                      carInfo,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text('License: ${car['carLicense'] ?? 'N/A'}'),
                        Text('Owner: ${car['ownerName'] ?? 'Unknown'}'),
                        Text('Last Visit: $lastVisit'),
                      ],
                    ),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to car details
                      _showCarDetails(car);
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
          // Add new car
        },
        child: Icon(Icons.add),
        tooltip: 'Add Car',
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (bool selected) {
          // Apply filter logic
          if (label == 'All') {
            setState(() {
              filteredCars = carsList;
              isSearching = false;
              searchController.clear();
            });
          } else {
            setState(() {
              isSearching = true;
              filteredCars = carsList.where((car) {
                final carBrand = car['carBrand']?.toString().toLowerCase() ?? '';
                return carBrand.contains(label.toLowerCase());
              }).toList();
            });
          }
        },
        selectedColor: Colors.blue.shade100,
        checkmarkColor: Colors.blue.shade800,
      ),
    );
  }

  void _showCarDetails(Map<String, dynamic> car) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Car Details',
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
                    // Navigate to edit car page
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            _detailRow('Brand', car['carBrand'] ?? 'N/A'),
            _detailRow('Model', car['carModel'] ?? 'N/A'),
            _detailRow('Year', car['year'] ?? 'N/A'),
            _detailRow('License Plate', car['carLicense'] ?? 'N/A'),
            _detailRow('Color', car['color'] ?? 'N/A'),
            _detailRow('Owner', car['ownerName'] ?? 'Unknown'),
            _detailRow('Owner Phone', car['ownerPhone'] ?? 'N/A'),
            _detailRow('Last Visit', car['lastVisit'] != null
                ? DateFormat('MMM d, yyyy').format(DateTime.parse(car['lastVisit']))
                : 'N/A'),

            SizedBox(height: 20),
            Text(
              'Service History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Expandable service history list
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                itemCount: 3, // Mocked service history
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Service ${index + 1}'),
                    subtitle: Text('${DateFormat('MMM d, yyyy').format(DateTime.now().subtract(Duration(days: 30 * (index + 1))))}'),
                    trailing: Icon(Icons.info_outline),
                    onTap: () {
                      // Show service details
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Schedule New Service'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                ),
                onPressed: () {
                  // Navigate to booking screen with this car pre-selected
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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