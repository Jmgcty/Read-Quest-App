import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../shared_preferences/shared_pref_enum.dart';
import '../../shared_preferences/shared_pref_helper.dart';

class ModuleService {
  static final _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';

  static Future<Map<String, dynamic>> uploadDocument({
    required File coverImage,
    required File docFile,
    required String name,
    required String description,
    required int uploadedBy,
  }) async {
    try {
      var uri = Uri.parse('$_baseUrl/api/module/upload');
      var request = http.MultipartRequest('POST', uri)
        ..fields['name'] = name
        ..fields['description'] = description
        ..fields['uploaded_by'] = uploadedBy.toString()
        ..files.add(await http.MultipartFile.fromPath('cover', coverImage.path))
        ..files.add(await http.MultipartFile.fromPath('file', docFile.path));

      var response = await request.send();
      return jsonDecode(await response.stream.bytesToString());
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<Map<String, dynamic>> getModulesByUploader() async {
    try {
      final id = await SharedPrefHelper.get(SharedPrefKey.userID) ?? 0;
      final response = await http.get(
        Uri.parse('$_baseUrl/api/module/uploader/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      log('response.body ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<Map<String, dynamic>> getModules() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/modules'),
        headers: {'Content-Type': 'application/json'},
      );
      log('response.body ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception(e);
    }
  }
}
