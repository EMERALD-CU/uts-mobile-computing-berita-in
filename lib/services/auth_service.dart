import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Kata kunci rahasia untuk menyimpan data di memori HP
  static const String _loginKey = 'isLoggedIn';
  static const String _emailKey = 'userEmail';

  // 1. Fungsi untuk MENYIMPAN status login (Dipanggil saat user klik "Lanjutkan/Daftar")
  static Future<void> saveLoginStatus(bool isLogged, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, isLogged);
    await prefs.setString(_emailKey, email);
  }

  // 2. Fungsi untuk MEMBACA status login (Dipanggil saat aplikasi pertama kali dibuka)
  static Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginKey) ?? false; // Jika belum pernah login, kembalikan 'false'
  }

  // 3. Fungsi ini untuk MENGAMBIL email yang sedang login
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey); // Mengembalikan email atau null jika tidak ada
  }

  // 4. Fungsi untuk MENGHAPUS status login (Dipanggil saat user klik Logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginKey);
    await prefs.remove(_emailKey);
  }
}