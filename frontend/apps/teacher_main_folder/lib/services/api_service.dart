import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const _base = 'http://localhost:8000/api/management-admin';
  static const teachersEndpoint = '$_base/teachers/';
  static const studentsEndpoint = '$_base/students/';

  static Future<List<dynamic>> fetchStudents() async {
    final resp = await http
        .get(Uri.parse(studentsEndpoint),
            headers: {'Content-Type': 'application/json'})
        .timeout(const Duration(seconds: 10));
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data is List) return data;
      if (data is Map && data.containsKey('results')) {
        return data['results'] as List;
      }
      return [];
    }
    throw Exception('Failed to fetch students: ${resp.statusCode}');
  }

  static Future<List<dynamic>> fetchTeachers() async {
    final resp = await http
        .get(Uri.parse(teachersEndpoint),
            headers: {'Content-Type': 'application/json'})
        .timeout(const Duration(seconds: 10));
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data is List) return data;
      if (data is Map && data.containsKey('results')) {
        return data['results'] as List;
      }
      return [];
    }
    throw Exception('Failed to fetch teachers: ${resp.statusCode}');
  }

  /// Fetch current logged-in teacher's profile
  static Future<Map<String, dynamic>?> fetchTeacherProfile() async {
    try {
      final resp = await http
          .get(Uri.parse('http://localhost:8000/api/teacher/profile/'),
              headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        return jsonDecode(resp.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch teacher profile: $e');
    }
  }
}

