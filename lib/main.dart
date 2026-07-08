import 'package:flutter/material.dart';
import 'views/login_screen.dart'; 
import 'views/home_screen.dart';
import 'services/auth_service.dart';
import 'package:provider/provider.dart';
import 'viewmodels/news_viewmodel.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NewsViewModel()),
      ],
      child: MaterialApp(
        title: 'BERITA.IN',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Roboto',
          primarySwatch: Colors.red,
        ),
        home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }
}