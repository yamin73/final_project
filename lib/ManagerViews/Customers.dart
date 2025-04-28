// Original imports
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../Utills/ClientConfig.dart';
// New imports
import '../ManagerModels/CustomerManagerModel.dart';
import '../ManagerModels//CarHistoryModel.dart';
import '../ManagerModels//BookingManagerModel.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  bool isLoading = true;
  // Change from List<Map<String, dynamic>> to List<CustomerManagerModel>
  List<CustomerManagerModel> customersList = [];
  List<CustomerManagerModel> filteredCustomers = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;