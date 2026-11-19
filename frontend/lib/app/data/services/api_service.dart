import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ApiService {
  // Automatically selects host for Android Emulator (10.0.2.2) vs iOS Simulator / macOS (127.0.0.1)
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5000/api';
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:5000/api';
      }
    } catch (_) {}
    return 'http://127.0.0.1:5000/api';
  }

  static Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };
    final token = StorageService.token;
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ========================
  // AUTH ENDPOINTS
  // ========================

  /// Send OTP to phone number
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/send-otp'),
      headers: _headers,
      body: jsonEncode({'phone': phone}),
    );
    return jsonDecode(response.body);
  }

  /// Verify OTP and get JWT token
  static Future<Map<String, dynamic>> verifyOtp(
      String phone, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-otp'),
      headers: _headers,
      body: jsonEncode({'phone': phone, 'otp': otp}),
    );
    return jsonDecode(response.body);
  }

  /// Get user profile
  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: _headers,
    );
    return jsonDecode(response.body);
  }

  /// Update user profile
  static Future<Map<String, dynamic>> updateProfile(
      Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/auth/profile'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  // ========================
  // LOAN ENDPOINTS
  // ========================

  /// Calculate EMI
  static Future<Map<String, dynamic>> calculateEmi(
      double amount, int tenure) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loans/calculate'),
      headers: _headers,
      body: jsonEncode({'loanAmount': amount, 'tenure': tenure}),
    );
    return jsonDecode(response.body);
  }

  /// Check loan eligibility
  static Future<Map<String, dynamic>> checkEligibility() async {
    final response = await http.get(
      Uri.parse('$baseUrl/loans/check-eligibility'),
      headers: _headers,
    );
    return jsonDecode(response.body);
  }

  /// Apply for a loan
  static Future<Map<String, dynamic>> applyLoan(
      Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loans/apply'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  /// Get all user's loans
  static Future<Map<String, dynamic>> getLoans({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    String url = '$baseUrl/loans?page=$page&limit=$limit';
    if (status != null) url += '&status=$status';

    final response = await http.get(
      Uri.parse(url),
      headers: _headers,
    );
    return jsonDecode(response.body);
  }

  /// Get single loan by ID
  static Future<Map<String, dynamic>> getLoanById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/loans/$id'),
      headers: _headers,
    );
    return jsonDecode(response.body);
  }

  /// Update loan status
  static Future<Map<String, dynamic>> updateLoanStatus(
      String id, String status,
      {String? remarks}) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/loans/$id/status'),
      headers: _headers,
      body: jsonEncode({
        'status': status,
        if (remarks != null) 'remarks': remarks,
      }),
    );
    return jsonDecode(response.body);
  }

  /// Get loan statistics
  static Future<Map<String, dynamic>> getLoanStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/loans/stats/summary'),
      headers: _headers,
    );
    return jsonDecode(response.body);
  }
}
