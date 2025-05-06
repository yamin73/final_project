import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_project/Models/UserModel.dart';
import 'package:final_project/Models/booking.dart';
import 'package:final_project/Models/Car.dart';
import 'package:final_project/ManagerModels/CarHistoryModel.dart';
import 'package:final_project/ManagerModels/BookingManagerModel.dart';
import 'package:final_project/ManagerModels/CustomerManagerModel.dart';
import 'package:final_project/ManagerModels/ServiceTypeMode.dart';

import 'ClientConfig.dart';

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

  // Booking History API
  static Future<List<Booking>> getUserBookings(String userID) async {
    try {
      final url = Uri.parse('${serverPath}bookings/getBookingHistory.php?userID=$userID');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Check if it's an error response
        if (jsonData is Map && jsonData.containsKey('result') && jsonData['result'] == '0') {
          throw Exception(jsonData['message'] ?? 'Failed to load bookings');
        }

        // Convert the JSON data to a list of Booking objects
        List<Booking> bookings = [];
        if (jsonData is List) {
          for (var item in jsonData) {
            bookings.add(Booking.fromJson(item));
          }
        }

        return bookings;
      } else {
        throw Exception('Failed to load bookings. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching bookings: $e');
    }
  }

  // Manager APIs
  static Future<List<CarHistoryModel>> getAllCarsHistory() async {
    try {
      // We'll use the existing getCars.php endpoint but join with required tables
      final url = Uri.parse('${serverPath}cars/getAllCarsHistory.php');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => CarHistoryModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load cars history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<BookingManagerModel>> getDailyBookings(String date) async {
    try {
      final url = Uri.parse('${serverPath}bookings/getDailyBookings.php?date=$date');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => BookingManagerModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load daily bookings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}