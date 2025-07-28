import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:read_quest/core/services/authentication/auth_model.dart';

import '../shared_preferences/shared_pref_enum.dart';
import '../shared_preferences/shared_pref_helper.dart';

class AuthHelper {
  static final _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';

  static Future<Map<String, dynamic>> login(
      {required String email, required String password}) async {
    try {
      final model = AuthModel(email: email, password: password);

      //
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(model.toLoginMap()),
      );

      // log('response.body ${response.body}');

      return jsonDecode(response.body);

      //
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<Map<String, dynamic>> signup(
      {required String name,
      required String email,
      required String password,
      required String confirmPassword}) async {
    try {
      final model = AuthModel(
          name: name,
          email: email,
          password: password,
          confirmPassword: confirmPassword);

      //
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(model.toSignupMap()),
      );

      // log('response.body ${response.body}');
      return jsonDecode(response.body);

      //
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<Map<String, dynamic>> logout() async {
    try {
      final session = await SharedPrefHelper.get(SharedPrefKey.session);
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'session_token': session}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception(e);
    }
  }
}
