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
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((car) => Car.fromJson(car)).toList();
      } else {
        throw Exception('Failed to get user cars: ${response.statusCode}');
      }
    } catch (e) {
      print('Get user cars error: $e');
      return [];
    }
  }

  // Booking APIs
  static Future<List<Booking>> getUserBookings(String userID) async {
    try {
      final url = Uri.parse('${serverPath}bookings/getUserBookings.php?userID=$userID');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((booking) => Booking.fromJson(booking)).toList();
      } else {
        throw Exception('Failed to get user bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('Get user bookings error: $e');
      return [];
    }
  }

  // Manager APIs
  static Future<List<CarHistoryModel>> getAllCarsHistory() async {
    try {
      final url = Uri.parse('${serverPath}cars/getAllCarsHistory.php');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((car) => CarHistoryModel.fromJson(car)).toList();
      } else {
        throw Exception('Failed to get cars history: ${response.statusCode}');
      }
    } catch (e) {
      print('Get cars history error: $e');
      return [];
    }
  }

  static Future<List<BookingManagerModel>> getDailyBookings(String date) async {
    try {
      final url = Uri.parse('${serverPath}bookings/getDailyBookings.php?date=$date');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((booking) => BookingManagerModel.fromJson(booking)).toList();
      } else {
        throw Exception('Failed to get daily bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('Get daily bookings error: $e');
      return [];
    }
  }

  static Future<List<CustomerManagerModel>> getAllCustomers() async {
    try {
      final url = Uri.parse('${serverPath}customers/getAllCustomers.php');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((customer) => CustomerManagerModel.fromJson(customer)).toList();
      } else {
        throw Exception('Failed to get customers: ${response.statusCode}');
      }
    } catch (e) {
      print('Get customers error: $e');
      return [];
    }
  }

  static Future<List<ServiceTypeModel>> getServiceTypes() async {
    try {
      final url = Uri.parse('${serverPath}bookings/getServiceTypes.php');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((service) => ServiceTypeModel.fromJson(service)).toList();
      } else {
        throw Exception('Failed to get service types: ${response.statusCode}');
      }
    } catch (e) {
      print('Get service types error: $e');
      return [];
    }
  }

  // Utility methods for common operations
  static Future<bool> updateBookingStatus(String bookingId, String status) async {
    try {
      final url = Uri.parse('${serverPath}bookings/updateBookingStatus.php');
      final response = await http.post(
        url,
        body: {
          'BookingID': bookingId,
          'status': status,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Update booking status error: $e');
      return false;
    }
  }
}