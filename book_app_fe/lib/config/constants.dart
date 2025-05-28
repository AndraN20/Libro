import 'package:flutter/material.dart';

// Navigation
final navigatorKey = GlobalKey<NavigatorState>();

// API Constants
const baseApiUrl = 'http://192.168.0.148:8000';
const apiConnectTimeout = Duration(seconds: 10);
const apiReceiveTimeout = Duration(seconds: 10);

// Route Names
class RouteNames {
  static const home = '/';
  static const login = '/login';
  static const loading = '/loading';
}

//Colors
class AppColors {
  // Culorile tale exacte
  static const yellow = Color(0xFFEFCA4E); // EFCA4E
  static const darkBlue1 = Color(0xFF100F4A); // 100F4A
  static const darkBlue2 = Color(0xFF181545); // 181545
  static const gray = Color(0xFF454545); // 454545
  static const purpleGray = Color(0xFF49498A); // 49498A
  static const primary = Color(0xFF4D4FB0); // 4D4FB0 (cea mai utilizată)
  static const lightPurple = Color(0xFF9999E8); // 9999E8
  static const brown = Color(0xFF9D5E30); // 9D5E30
  static const background = Color(0xFFD9D9E2); // D9D9E2 (background/texte)
  static const pink = Color(0xFFFD6584);
}
