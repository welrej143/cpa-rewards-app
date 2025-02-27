import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For system overlay control
import 'package:firebase_core/firebase_core.dart'; // Import Firebase
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Firebase.initializeApp(); // ✅ Initialize Firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black, // Ensure all screens have a black background
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.withOpacity(0.3), // Semi-transparent AppBar
          elevation: 0, // Remove shadow
          iconTheme: const IconThemeData(color: Colors.green),
          systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.black, // Transparent status bar
            statusBarIconBrightness: Brightness.light, // White icons
            systemNavigationBarColor: Colors.black, // Black navigation bar (for Android)
            systemNavigationBarIconBrightness: Brightness.light, // White nav icons
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
