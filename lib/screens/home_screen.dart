import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpa_rewards_app/screens/offer_screen.dart';
import 'package:cpa_rewards_app/screens/wallet_screen.dart';
import 'package:cpa_rewards_app/screens/transaction_screen.dart';
import 'package:cpa_rewards_app/services/device_info_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  double _balance = 50.00; // Default balance if no earnings yet

  @override
  void initState() {
    super.initState();
    _fetchBalance(); // Fetch balance when the screen loads
  }

  /// ✅ **Fetch balance from Firestore**
  Future<void> _fetchBalance() async {
    try {
      String deviceId = await DeviceInfoService.getUserDevice();
      double totalEarnings = 0.00;

      print('ahahaha: '+deviceId);

      QuerySnapshot completedOffers = await FirebaseFirestore.instance
          .collection('completed_offers')
          .where('deviceId', isEqualTo: deviceId)
          .get();

      for (var doc in completedOffers.docs) {
        totalEarnings += (doc['payout'] as num).toDouble(); // Convert to double
      }

      setState(() {
        _balance = 50.00 + totalEarnings; // ✅ Add $50 bonus
      });

      print("🔥 Balance updated: $_balance");
    } catch (e) {
      print("❌ Error fetching balance: $e");
    }
  }

  // Define screens for bottom navigation
  final List<Widget> _screens = [
    const HomeContent(),  // Home
    const OfferScreen(),  // Offers
    const WalletScreen(), // Wallet
    const TransactionScreen(), // Transactions
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark mode
      appBar: AppBar(
        backgroundColor: Colors.grey.withOpacity(0.3),
        elevation: 4, // ✅ Adds shadow below AppBar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // ✅ Space out elements
          children: [
            const Text(
              "Rewards App",
              style: TextStyle(fontSize: 16),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1), // ✅ Background for balance
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    "${_balance.toStringAsFixed(2)} ", // ✅ Show dynamic balance
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.attach_money, // ✅ Dollar icon
                    size: 18,
                    color: Colors.green, // ✅ Green color for the dollar icon
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex], // ✅ Show selected screen
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green, // ✅ Active icon color
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: "Offers"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Wallet"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Transactions"),
        ],
      ),
    );
  }
}

/// ✅ **Home Content with Reward & How It Works Cards**
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          _buildRewardCard(), // ✅ Custom reward card with `gift_icon.png`
          const SizedBox(height: 30),
          _buildHowItWorksCards(), // ✅ "How It Works" cards (Earn & Withdraw)
        ],
      ),
    );
  }

  /// ✅ **Custom Reward Card UI with `gift_icon.png`**
  Widget _buildRewardCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: Colors.grey[900], // Dark background for card
        elevation: 4, // Adds slight shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/icons/gift_icon.png', // ✅ Updated to use `gift_icon.png`
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Get Rewarded for completing tasks or surveys",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Text(
                    "Earn Free ",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    "USDT",
                    style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ **"How It Works" Section**
  Widget _buildHowItWorksCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Text(
            "How it Works?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _buildCard("Earn", "Choose and complete from massive selection of hundreds of offers",
              Icons.monetization_on),
          const SizedBox(height: 10),
          _buildCard("Withdraw", "Choose to withdraw in cryptocurrency or gift cards",
              Icons.account_balance_wallet),
        ],
      ),
    );
  }

  /// ✅ **Card UI for "Earn" & "Withdraw"**
  Widget _buildCard(String title, String description, IconData icon) {
    return Card(
      color: Colors.grey[900], // Dark background for card
      elevation: 3, // Slight shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.green, size: 30), // ✅ Green icon
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ),
    );
  }
}
