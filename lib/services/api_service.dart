import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL for the API
  final String baseUrl =
      "https://usmiley-telemetry.onrender.com/api/v1/dashBoardInfo1";

  // Common headers for the API requests
  final Map<String, String> headers = {
    "Content-Type": "application/json; charset=utf-8"
  };

  /// Fetches data from the API for a given device ID.
  ///
  /// Returns a [Map<String, String>] containing various health metrics.
  /// Throws an [Exception] if the HTTP request fails.
  Future<Map<String, String>> fetchData(String deviceId) async {
    final Map<String, String> dataMap = {};

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode({"id": deviceId}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        dataMap['heartRate'] = jsonResponse['heartRate']?.toString() ?? 'N/A';
        dataMap['bloodOxygen'] =
            jsonResponse['bloodOxygen']?.toString() ?? 'N/A';
        dataMap['stress'] = jsonResponse['stress']?.toString() ?? 'N/A';
        dataMap['hrv'] = jsonResponse['hrv']?.toString() ?? 'N/A';
        dataMap['bodyTemp'] = jsonResponse['bodyTemp']?.toString() ?? 'N/A';
        dataMap['bloodPressure'] =
            jsonResponse['bloodPressure']?.toString() ?? 'N/A';
      } else {
        // Handle different status codes with more specific messages
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Log the error for debugging purposes
      print('Error fetching data: $e');
      throw Exception('Failed to load data: $e');
    }

    return dataMap;
  }
}
