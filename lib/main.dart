import 'package:flutter/material.dart';
import 'views/login_screen.dart'; // Sesuaikan dengan path folder kamu

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Berita.in',
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto', // Bisa disesuaikan jika kamu pakai font khusus di Figma
      ),
      home: const LoginScreen(), // Mengarahkan langsung ke halaman Login
    );
  }
}