import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class InstitutionService {
  static final _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';

  static Future<Map<String, dynamic>> checkUserInstitution(int userID) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/institution/member/$userID'),
        headers: {'Content-Type': 'application/json'},
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<Map<String, dynamic>> joinInstitution(
      {required String institutionID,
      required String key,
      required int userID}) async {
    //

    //
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/institution/join'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'institutional_id': institutionID,
          'key': key,
          'user_id': userID,
        }),
      );

      return jsonDecode(response.body);

      //
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<Map<String, dynamic>> cancelMembershipRequest(
      int userID) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/institution/cancel'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userID}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception(e);
    }
  }
}
