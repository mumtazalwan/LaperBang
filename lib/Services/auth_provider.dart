import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/auth_model.dart';

class AuthProvider extends ChangeNotifier {
  bool isPasswordVisible = false;
  bool isLoading = false;

  UserModel? currentUser;
  String? authToken;

  final String baseUrl = "https://laper-bang-backend.vercel.app/api/v1";

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  // --- Fungsi Manajemen Token Lokal ---

  Future<void> _saveAuthData(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    authToken = token;
  }

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');

    if (authToken != null && authToken!.isNotEmpty) {
      // Ambil data profil setelah token ditemukan
      await fetchUserProfile();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    // 1. Beritahu backend untuk menghancurkan token/sesi jika token tersedia
    if (authToken != null) {
      try {
        await http.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        );
      } catch (e) {
        debugPrint("Error saat memanggil API logout: $e");
      }
    }

    // 2. Hapus token dari memori penyimpanan lokal HP
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');

    // 3. Kosongkan state di Provider
    authToken = null;
    currentUser = null;
    notifyListeners();
  }

  // --- Fungsi Tarik Data Profil (GET /me) ---

  Future<void> fetchUserProfile() async {
    if (authToken == null) return;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == true && responseData['data'] != null) {
          currentUser = UserModel.fromJson(responseData['data']);
          notifyListeners();
        }
      } else {
        debugPrint("Gagal mengambil profil: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error saat mengambil profil: $e");
    }
  }

  // --- Fungsi Autentikasi ---

  Future<bool> register({
    required String username,
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'name': name,
          'email': email,
          'password': password,
          'role': 'customer',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        AuthResponseModel authData = AuthResponseModel.fromJson(responseData);

        if (authData.success && authData.user != null) {
          currentUser = authData.user;
          if (authData.token != null) {
            await _saveAuthData(authData.token!);
          }
          isLoading = false;
          notifyListeners();
          return true;
        }
      }

      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint("Error saat register: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        AuthResponseModel authData = AuthResponseModel.fromJson(responseData);

        if (authData.success && authData.user != null) {
          currentUser = authData.user;
          if (authData.token != null) {
            await _saveAuthData(authData.token!);
          }
          isLoading = false;
          notifyListeners();
          return true;
        }
      }

      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint("Error saat login: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
