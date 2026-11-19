import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors (from Figma design)
  static const Color primaryDark = Color(0xFF0D2B5C);
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF1E88E5);
  static const Color accentBlue = Color(0xFF2196F3);

  // CreditSea Brand
  static const Color brandGreen = Color(0xFF4CAF50);
  static const Color brandTeal = Color(0xFF26A69A);

  // Background
  static const Color background = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;
  static const Color surfaceLight = Color(0xFFF0F4F8);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textWhite = Colors.white;

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Loan Status Colors
  static const Color statusSubmitted = Color(0xFF3B82F6);
  static const Color statusUnderReview = Color(0xFFF59E0B);
  static const Color statusApproved = Color(0xFF10B981);
  static const Color statusRejected = Color(0xFFEF4444);
  static const Color statusDisbursed = Color(0xFF8B5CF6);

  // Border & Divider
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, Color(0xFF1A4B8C)],
  );

  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, accentBlue],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryDark, Color(0xFF0F3D7A)],
  );
}
