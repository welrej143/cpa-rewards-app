import 'package:flutter/material.dart';
import '../models/completed_offer_model.dart';

class CompletedOfferCard extends StatelessWidget {
  final CompletedOffer offer;

  const CompletedOfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black87, // Dark mode
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: Icon(Icons.check_circle, color: Colors.greenAccent),
        title: Text(offer.title, style: TextStyle(color: Colors.white, fontSize: 16)),
        subtitle: Text(
          "Earned: \$${offer.payout.toStringAsFixed(2)}",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          offer.timestamp,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
