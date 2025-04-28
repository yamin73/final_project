import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_project/Utills/ClientConfig.dart';
import 'package:final_project/Models/UserModel.dart';
import 'package:final_project/Models/booking.dart';
import 'package:final_project/Models/Car.dart';
import 'package:final_project/ManagerModels/CarHistoryModel.dart';
import 'package:final_project/ManagerModels/BookingManagerModel.dart';
import 'package:final_project/ManagerModels/CustomerManagerModel.dart';
import 'package:final_project/ManagerModels/ServiceTypeMode.dart';

class ApiService {
  // Authentication APIs
  static Future<Map<String, dynamic>> login(String phoneNumber, String password) async {
    try {
      final url = Uri.parse('${serverPath}login/checkLogin.php?phoneNumber=$phoneNumber&password=$password');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      print('Login error: $e');
      return {'userID': 0, 'message': 'Connection error: $e'};
    }
  }

  static Future<Map<String, dynamic>> register(String name, String phoneNumber, String password) async {
    try {
      final url = Uri.parse('${serverPath}users/insertUser.php?Name=$name&phoneNumber=$phoneNumber&Password=$password');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to register: ${response.statusCode}');
      }
    } catch (e) {
      print('Register error: $e');
      return {'result': '0', 'message': 'Connection error: $e'};
    }
  }

  // User Profile APIs
  static Future<Map<String, dynamic>> getUserProfile(String userID) async {
    try {
      final url = Uri.parse('${serverPath}users/getUserProfile.php?userID=$userID');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get user profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Get user profile error: $e');
      return {'result': '0', 'message': 'Connection error: $e'};
    }
  }

  // Car APIs
  static Future<List<Car>> getUserCars(String userID) async {
    try {
      final url = Uri.parse('${serverPath}cars/getUserCars.php?userID=$userID');