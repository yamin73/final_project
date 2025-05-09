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
  String? errorMessage;
  String selectedFilter = "All";
  List<String> filterOptions = ["All", "Recently Added", "Most Visits"];

  @override
  void initState() {
    super.initState();
    fetchCarsHistory();
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
            errorMessage = 'Failed to parse car data: $e';
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

  void _filterCars(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredCars = carsList;
      });
      return;
    }

    setState(() {
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

  void _applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;

      switch (filter) {
        case "Recently Added":
        // Just a placeholder - in a real app, you'd sort by creation date
          filteredCars = List.from(carsList);
          break;
        case "Most Visits":
          filteredCars = List.from(carsList)
            ..sort((a, b) => (b.visitsCount ?? 0).compareTo(a.visitsCount ?? 0));
          break;
        default: // "All"
          filteredCars = List.from(carsList);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchCarsHistory,
        child: Column(
          children: [
            // Filter and stats row
            Container(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                children: [
                  // Filter chips
                  Container(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: filterOptions.map((filter) =>
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(filter),
                              selected: selectedFilter == filter,
                              backgroundColor: Colors.grey.shade100,
                              selectedColor: Theme.of(context).primaryColor.withOpacity(0.15),
                              labelStyle: TextStyle(
                                color: selectedFilter == filter
                                    ? Theme.of(context).primaryColor
                                    : Colors.black87,
                                fontWeight: selectedFilter == filter
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  _applyFilter(filter);
                                }
                              },
                            ),
                          ),
                      ).toList(),
                    ),
                  ),
                  SizedBox(height: 12),

                  // Stats row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Cars',
                          carsList.length.toString(),
                          Icons.directions_car,
                          Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Recent Services',
                          '0',
                          Icons.history,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Cars list
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage != null
                  ? _buildErrorView()
                  : filteredCars.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_car_outlined,
                        size: 64, color: Colors.grey.shade400),
                    SizedBox(height: 16),
                    Text(
                      'No cars available',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.only(top: 8),
                itemCount: filteredCars.length,
                itemBuilder: (context, index) {
                  final car = filteredCars[index];
                  return _buildCarCard(car);
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
              errorMessage ?? 'Failed to load car data',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: fetchCarsHistory,
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
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
    );
  }

  Widget _buildCarCard(CarHistoryModel car) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showCarDetails(car);
        },
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // Car icon or image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.directions_car,
                  color: Theme.of(context).primaryColor,
                  size: 30,
                ),
              ),
              SizedBox(width: 12),

              // Car details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${car.year ?? ''} ${car.carBrand ?? ''} ${car.carModel ?? ''}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    if (car.carLicense != null && car.carLicense!.isNotEmpty)
                      Text(
                        car.carLicense!,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.person, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          car.ownerName ?? 'Unknown Owner',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Visit count badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
            ],
          ),
        ),
      ),
    );
  }

  void _showCarDetails(CarHistoryModel car) {
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

              // Car header
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.directions_car,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${car.year ?? ''} ${car.carBrand ?? ''} ${car.carModel ?? ''}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        if (car.carLicense != null && car.carLicense!.isNotEmpty)
                          Text(
                            car.carLicense!,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              Divider(height: 32),

              // Owner details
              Text(
                'Owner Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 12),
              _buildDetailRow(Icons.person, 'Name', car.ownerName ?? 'Unknown'),
              SizedBox(height: 8),
              _buildDetailRow(Icons.phone, 'Phone', car.ownerPhone ?? 'Not available'),

              Divider(height: 32),

              // Service history
              Text(
                'Service History',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 12),
              _buildDetailRow(
                  Icons.event,
                  'Last Visit',
                  car.lastVisit != null && car.lastVisit != 'Unknown'
                      ? _formatDate(car.lastVisit)
                      : 'Never visited'
              ),
              SizedBox(height: 8),
              _buildDetailRow(
                  Icons.history,
                  'Total Visits',
                  '${car.visitsCount ?? 0} visits'
              ),

              SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.history),
                      label: Text('View History'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        // View detailed history
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('New Booking'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        // Create new booking for this car
                        Navigator.pop(context);
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: Colors.grey.shade700),
        ),
        SizedBox(width: 12),
        Column(
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
      ],
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