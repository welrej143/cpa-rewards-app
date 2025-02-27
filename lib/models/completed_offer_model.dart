class CompletedOffer {
  final String offerId;
  final String title;
  final double payout;
  final String timestamp;

  CompletedOffer({
    required this.offerId,
    required this.title,
    required this.payout,
    required this.timestamp,
  });

  factory CompletedOffer.fromJson(Map<String, dynamic> json) {
    return CompletedOffer(
      offerId: json["offer_id"] ?? "N/A",
      title: json["title"] ?? "Unknown Offer",
      payout: double.tryParse(json["payout"].toString()) ?? 0.0,
      timestamp: json["timestamp"] ?? "Unknown",
    );
  }
}
