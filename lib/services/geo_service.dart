import 'dart:convert';
import 'package:http/http.dart' as http;

class GeoService {
  /// Fetches the user's country based on their IP address.
  static Future<String> getUserCountry() async {
    try {
      final response = await http.get(Uri.parse("https://api.country.is"));

      print("API Raw Response: ${response.body}"); // Debugging

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded.containsKey('country')) {
          print("Country Detected via IP: ${decoded['country']}");
          return decoded['country'];
        } else {
          print("Invalid API response format");
        }
      } else {
        print("API Error: Status Code ${response.statusCode}");
      }
    } catch (e) {
      print("Error getting country from IP: $e");
    }

    return "US"; // Default to US if API fails
  }
}
