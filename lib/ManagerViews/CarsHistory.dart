// Original imports
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../Utills/ClientConfig.dart';
// New import
import '../ManagerModels//CarHistoryModel.dart';

class CarsHistory extends StatefulWidget {
  const CarsHistory({Key? key}) : super(key: key);

  @override
  _CarsHistoryState createState() => _CarsHistoryState();
}

class _CarsHistoryState extends State<CarsHistory> {
  bool isLoading = true;
  // Change from List<Map<String, dynamic>> to List<CarHistoryModel>
  List<CarHistoryModel> carsList = [];
  List<CarHistoryModel> filteredCars = [];
  TextEditingController searchController = TextEditingController();
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
          // Convert to CarHistoryModel objects
          carsList = data.map((item) => CarHistoryModel.fromJson(item)).toList();
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
        // Use model properties instead of map keys
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