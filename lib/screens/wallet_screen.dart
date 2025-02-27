import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpa_rewards_app/services/device_info_service.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double _balance = 50.00; // ✅ Initial balance of $50
  final double _minWithdrawal = 500.00; // ✅ Minimum withdrawal amount
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  /// ✅ **Fetch user balance from Firestore**
  Future<void> _fetchBalance() async {
    try {
      String deviceId = await DeviceInfoService.getUserDevice();

      // Query Firestore for completed offers matching the user's deviceId
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("completed_offers")
          .where("deviceId", isEqualTo: deviceId)
          .get();

      double totalPayout = snapshot.docs.fold(0, (sum, doc) {
        return sum + (doc["payout"] as num).toDouble();
      });

      setState(() {
        _balance = 50.00 + totalPayout; // ✅ Add $50 initial balance
        _isLoading = false;
      });

      print("🔥 Balance updated: $_balance");
    } catch (e) {
      print("❌ Error fetching balance: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark mode
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// ✅ **Balance Display**
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Current Balance",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.green)
                      : Text(
                    "\$${_balance.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ✅ **Minimum Withdrawal Info**
            Text(
              "Minimum withdrawal amount: \$${_minWithdrawal.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.redAccent, fontSize: 14),
            ),

            const SizedBox(height: 30),

            /// ✅ **Withdrawal Options**
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Withdraw via",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),

            _buildWithdrawOption(Icons.credit_card, "Credit/Debit Card"),
            _buildWithdrawOption(Icons.paypal, "PayPal"),
            _buildWithdrawOption(Icons.currency_bitcoin, "Bitcoin"),
          ],
        ),
      ),
    );
  }

  /// ✅ **Reusable Withdrawal Option Button**
  Widget _buildWithdrawOption(IconData icon, String method) {
    return Card(
      color: Colors.grey[900], // Dark background for card
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.green, size: 30),
        title: Text(
          method,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
        onTap: () => _showWithdrawalPopup(method),
      ),
    );
  }

  /// ✅ **Show Alert Dialog if balance is below the minimum withdrawal**
  void _showWithdrawalPopup(String method) {
    if (_balance < _minWithdrawal) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text("Withdrawal Error", style: TextStyle(color: Colors.white)),
            content: Text(
              "You need at least \$${_minWithdrawal.toStringAsFixed(2)} to withdraw via $method.",
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK", style: TextStyle(color: Colors.green)),
              ),
            ],
          );
        },
      );
    } else {
      // Handle actual withdrawal process here
      print("Proceed with withdrawal via $method");
    }
  }
}
