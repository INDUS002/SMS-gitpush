import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:core/api/endpoints.dart';

/// Base API handler
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _authToken;
  Duration _timeout = const Duration(seconds: 30);

  // Set authentication token
  void setAuthToken(String? token) {
    _authToken = token;
  }

  // Get authentication token
  String? get authToken => _authToken;

  // Set request timeout
  void setTimeout(Duration duration) {
    _timeout = duration;
  }

  // Get default headers
  Map<String, String> _getHeaders({Map<String, String>? additionalHeaders}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  // GET request
  Future<ApiResponse> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      Uri uri = Uri.parse(Endpoints.buildUrl(endpoint));
      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParameters);
      }

      final response = await http
          .get(uri, headers: _getHeaders(additionalHeaders: headers))
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // POST request
  Future<ApiResponse> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(Endpoints.buildUrl(endpoint));
      final response = await http
          .post(
            uri,
            headers: _getHeaders(additionalHeaders: headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // PUT request
  Future<ApiResponse> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(Endpoints.buildUrl(endpoint));
      final response = await http
          .put(
            uri,
            headers: _getHeaders(additionalHeaders: headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // PATCH request
  Future<ApiResponse> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(Endpoints.buildUrl(endpoint));
      final response = await http
          .patch(
            uri,
            headers: _getHeaders(additionalHeaders: headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // DELETE request
  Future<ApiResponse> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(Endpoints.buildUrl(endpoint));
      final response = await http
          .delete(uri, headers: _getHeaders(additionalHeaders: headers))
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // Handle HTTP response
  ApiResponse _handleResponse(http.Response response) {
    try {
      final statusCode = response.statusCode;
      dynamic body;
      
      if (response.body.isNotEmpty) {
        try {
          body = jsonDecode(response.body);
        } catch (e) {
          // If JSON parsing fails, return the raw body as error
          return ApiResponse.error(
            'Invalid JSON response: ${response.body}',
            statusCode: statusCode,
          );
        }
      }

      if (statusCode >= 200 && statusCode < 300) {
        // For successful responses, body could be Map or List
        return ApiResponse.success(
          data: body,
          statusCode: statusCode,
        );
      } else {
        // For error responses, try to extract error message
        String errorMessage = 'Request failed with status $statusCode';
        if (body is Map<String, dynamic>) {
          errorMessage = body['message'] as String? ??
              body['error'] as String? ??
              (body['errors'] is Map ? 'Validation errors' : errorMessage);
        } else if (body is String) {
          errorMessage = body;
        }
        
        return ApiResponse.error(
          errorMessage,
          statusCode: statusCode,
          data: body,
        );
      }
    } catch (e) {
      return ApiResponse.error('Failed to parse response: ${e.toString()}');
    }
  }
}

/// API Response model
class ApiResponse {
  final bool success;
  final dynamic data;
  final String? error;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.statusCode,
  });

  factory ApiResponse.success({
    dynamic data,
    int? statusCode,
  }) {
    return ApiResponse(
      success: true,
      data: data,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(
    String error, {
    int? statusCode,
    dynamic data,
  }) {
    return ApiResponse(
      success: false,
      error: error,
      statusCode: statusCode,
      data: data,
    );
  }
}

