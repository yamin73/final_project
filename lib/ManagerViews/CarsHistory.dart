import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../Utills/ClientConfig.dart';
import '../ManagerModels/CarHistoryModel.dart';

class CarsHistory extends StatefulWidget {
  const CarsHistory({Key? key}) : super(key: key);

  @override
  _CarsHistoryState createState() => _CarsHistoryState();
}

class _CarsHistoryState extends State<CarsHistory> {
  bool isLoading = true;
  List<CarHistoryModel> carsList = [];
  List<CarHistoryModel> filteredCars = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  String? errorMessage;

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
      errorMessage = null;
    });

    try {
      // Try using getCars.php instead of getAllCarsHistory.php
      final url = Uri.parse('${serverPath}cars/getCars.php');
      print("Fetching cars from: $url");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        try {
          print("Response: ${response.body}");
          final List<dynamic> data = json.decode(response.body);

          // Convert raw data to CarHistoryModel objects and add more info
          List<CarHistoryModel> cars = [];

          for (var item in data) {
            print("Processing item: $item");
            // Make sure all values are properly converted to strings
            final carId = item['carID']?.toString() ?? '';
            final userId = item['userID']?.toString() ?? '';
            final carModelId = item['carModelID']?.toString() ?? '';
            final year = item['year']?.toString() ?? '';
            final carModelName = item['carModelName']?.toString() ?? '';
            final carBrandName = item['carBrandName']?.toString() ?? '';

            // Create a CarHistoryModel with available data
            final car = CarHistoryModel(
                carId: carId,
                carBrand: carBrandName,
                carModel: carModelName,
                year: year,
                // Add some default values for missing fields
                lastVisit: 'Unknown',
                visitsCount: 0,
                ownerName: 'Owner #$userId',
                ownerPhone: 'Not available'
            );

            cars.add(car);
          }

          setState(() {
            carsList = cars;
            filteredCars = cars;
            isLoading = false;
          });
        } catch (e) {
          print("Error parsing data: $e");
          setState(() {
            isLoading = false;
            errorMessage = 'Failed to parse car data: $e\nResponse: ${response.body.substring(0, min(100, response.body.length))}...';
          });
        }
      } else {
        print("Server error: ${response.statusCode}");
        setState(() {
          isLoading = false;
          errorMessage = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      print("Network error: $e");
      setState(() {
        isLoading = false;
        errorMessage = 'Network error: $e';
      });
    }
  }

  int min(int a, int b) {
    return a < b ? a : b;
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
        final carBrand = car.carBrand?.toLowerCase() ?? '';
        final carModel = car.carModel?.toLowerCase() ?? '';
        final carLicense = car.carLicense?.toLowerCase() ?? '';
        final ownerName = car.ownerName?.toLowerCase() ?? '';

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
          // Search bar
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search cars',
                hintText: 'Enter car brand, model, license, or owner',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    _filterCars('');
                  },
                )
                    : null,
              ),
              onChanged: _filterCars,
            ),
          ),

          // Stats row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Cars',
                    carsList.length.toString(),
                    Icons.directions_car,
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Recent Services',
                    '0', // We don't have this data yet
                    Icons.history,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Cars list
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
                    onPressed: fetchCarsHistory,
                    child: Text('Try Again'),
                  ),
                ],
              ),
            )
                : filteredCars.isEmpty
                ? Center(
              child: isSearching
                  ? Text('No cars match your search')
                  : Text('No cars available'),
            )
                : ListView.builder(
              itemCount: filteredCars.length,
              itemBuilder: (context, index) {
                final car = filteredCars[index];
                return _buildCarCard(car);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarCard(CarHistoryModel car) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(Icons.directions_car, color: Colors.blue),
        ),
        title: Text(
          '${car.year ?? ''} ${car.carBrand ?? ''} ${car.carModel ?? ''}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            if (car.carLicense != null && car.carLicense!.isNotEmpty)
              Row(
                children: [
                  Icon(Icons.confirmation_number, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(car.carLicense!),
                ],
              ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(car.ownerName ?? 'Unknown Owner'),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            car.visitsCount != null && car.visitsCount! > 0
                ? '${car.visitsCount} visits'
                : 'No visits',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                // Owner details
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Owner',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            car.ownerName ?? 'Unknown',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.phone, size: 16, color: Colors.blue),
                              SizedBox(width: 4),
                              Text(car.ownerPhone ?? 'No phone'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Service history
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last Visit',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            car.lastVisit != null && car.lastVisit != 'Never'
                                ? _formatDate(car.lastVisit)
                                : 'Never visited',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Visits',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${car.visitsCount ?? 0}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      icon: Icon(Icons.history),
                      label: Text('View History'),
                      onPressed: () {
                        // View detailed history
                      },
                    ),
                    SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('New Booking'),
                      onPressed: () {
                        // Create new booking for this car
                      },
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

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown';

    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}