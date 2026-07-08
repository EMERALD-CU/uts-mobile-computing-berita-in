import 'package:flutter/material.dart';
import 'views/login_screen.dart'; 
import 'views/home_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await AuthService.checkLoginStatus();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Berita.in',
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto', 
      ),
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}