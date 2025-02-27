import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OfferCard extends StatefulWidget {
  final Map<String, dynamic> offer;
  final Function(String offerId, bool completed) onOfferCompletion;

  const OfferCard({super.key, required this.offer, required this.onOfferCompletion});

  @override
  _OfferCardState createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  void _openOffer() async {
    final Uri offerUri = Uri.parse(widget.offer['offerlink']);

    if (await canLaunchUrl(offerUri)) {
      await launchUrl(offerUri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not open URL: ${widget.offer['offerlink']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.withOpacity(0.3),
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              widget.offer['offerphoto'] ?? '',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: Colors.grey[800],
                  child: Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.offer['title'] ?? "No Title",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 5),
                Text(
                  widget.offer['description'] ?? "No description available",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                SizedBox(height: 5),
                Text(
                  "Payout: \$${widget.offer['payout'] ?? "0.00"}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _openOffer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text("Claim Reward", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

