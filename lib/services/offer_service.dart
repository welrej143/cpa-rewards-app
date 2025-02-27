import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'device_info_service.dart';

class OfferService {
  static const String userId = "845826";
  static const String pubKey = "82b9ff1ab5244e111d15fb14283f0751";

  /// Fetches available CPA offers and removes completed offers
  static Future<List<Map<String, dynamic>>> fetchOffers(String country) async {
    try {
      // Get unique device ID
      String deviceId = await DeviceInfoService.getUserDevice();

      if (country.isEmpty || country.length != 2) {
        print("Invalid country code, defaulting to US.");
        country = "US";
      }

      // Fetch completed offers from Firestore
      List<String> completedOfferIds = await _getCompletedOffers(deviceId);

      // Detect Device Type
      String deviceType = _getDeviceType();
      print("Device Type: $deviceType");

      final apiUrl =
          "https://www.cpagrip.com/common/offer_feed_json.php?"
          "user_id=$userId&key=$pubKey&country=$country"
          "&showmobile=yes&subid=$deviceId&platform=$deviceType";

      print("Fetching Offers from: $apiUrl");

      final response = await http.get(Uri.parse(apiUrl));
      print("API Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['offers'] == null || data['offers'] is! List) {
          print("No offers available.");
          return [];
        }

        List<Map<String, dynamic>> offers = List<Map<String, dynamic>>.from(data['offers']);

        // Map the data and include Net CR
        List<Map<String, dynamic>> mappedOffers = offers.map((offer) {
          return {
            "offer_id": offer["offer_id"] ?? "N/A",
            "title": offer["title"] ?? "Untitled Offer",
            "description": offer["description"] ?? "No description available",
            "payout": offer["payout"] != null
                ? double.tryParse(offer["payout"].toString())! * 10
                : 0.00, // Multiply payout by 10
            "offerlink": offer["offerlink"] ?? "",
            "offerphoto": offer["offerphoto"] ?? "",
            "type": offer["type"] ?? "",
            "accepted_countries": offer["accepted_countries"] ?? "N/A",
            "net_cr": offer["net_cr"] != null
                ? double.tryParse(offer["net_cr"].toString()) ?? 0.0
                : 0.0, // Net CR percentage
          };
        }).toList();

        // Remove offers that have already been completed
        mappedOffers.removeWhere((offer) => completedOfferIds.contains(offer["offer_id"]));

        // Sort by highest Net CR
        mappedOffers.sort((a, b) => b["net_cr"].compareTo(a["net_cr"]));

        return mappedOffers;
      } else {
        print("API returned status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching offers: $e");
      return [];
    }
  }

  /// ✅ Fetch completed offers from Firestore
  static Future<List<String>> _getCompletedOffers(String deviceId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("completed_offers")
          .where("deviceId", isEqualTo: deviceId)
          .get();

      return snapshot.docs.map((doc) => doc["offerId"].toString()).toList();
    } catch (e) {
      print("Error fetching completed offers: $e");
      return [];
    }
  }

  /// ✅ **Detects the device type (Android, iOS, or Desktop)**
  static String _getDeviceType() {
    if (Platform.isAndroid) {
      return "android";
    } else if (Platform.isIOS) {
      return "ios";
    } else {
      return "desktop"; // Default for Web & other platforms
    }
  }
}
