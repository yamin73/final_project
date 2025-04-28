// Original imports 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../Utills/ClientConfig.dart';
// New import
import '../ManagerModels//BookingManagerModel.dart';

class HomeManagerPage extends StatefulWidget {
  const HomeManagerPage({Key? key}) : super(key: key);

  @override
  _HomeManagerPageState createState() => _HomeManagerPageState();
}

class _HomeManagerPageState extends State<HomeManagerPage> {
  bool isLoading = true;
  // Change from List<Map<String, dynamic>> to List<BookingManagerModel>
  List<BookingManagerModel> todayBookings = [];
  DateTime selectedDate = DateTime.now();