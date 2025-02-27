import 'package:flutter/material.dart';
import '../services/offer_service.dart';
import '../services/geo_service.dart';
import '../widgets/offer_card.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  List<dynamic> _offers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  /// ✅ Load Offers from API & Handle Errors
  Future<void> _loadOffers() async {
    try {
      String country = await GeoService.getUserCountry();
      List<dynamic> offers = await OfferService.fetchOffers(country);

      setState(() {
        _offers = offers;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading offers: $e");
      setState(() => _isLoading = false);
    }
  }

  /// ✅ Callback Function When Offer is Completed
  void _onOfferCompleted(String offerId, bool completed) {
    if (completed) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Offer $offerId completed! Reward credited."))
      );
      // Optionally: Refresh Offers (if needed)
      _loadOffers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark Mode
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : _offers.isEmpty
          ? Center(
        child: Text(
          "No offers available",
          style: TextStyle(color: Colors.white70),
        ),
      )
          : Padding(
            padding: const EdgeInsets.all(15),
            child: ListView.builder(
                    itemCount: _offers.length,
                    itemBuilder: (context, index) => OfferCard(
            offer: _offers[index],
            onOfferCompletion: _onOfferCompleted, // ✅ Pass Callback
                    ),
                  ),
          ),
    );
  }
}
