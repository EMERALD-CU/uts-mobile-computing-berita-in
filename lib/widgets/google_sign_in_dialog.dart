import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../views/home_screen.dart';
import '../views/register_screen.dart';
import '../data/app_data.dart';
import '../services/auth_service.dart';

void showGoogleSignInDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Dialog(
          backgroundColor: const Color(0xFFFCEAE8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: AppColors.primaryRed, borderRadius: BorderRadius.circular(8)),
                  alignment: Alignment.center,
                  child: const Text('b', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                const Text('Pilih akun', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 4),
                const Text('untuk melanjutkan ke BERITA.IN', style: TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 24),

                // Akun 1 -> Masuk ke Home Page
                // Render akun dinamis dari AppData
              ...AppData.savedAccounts.map((account) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Color(account['color']),
                    child: Text(account['initial'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(account['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(account['email']),
                  onTap: () async {
                    await AuthService.saveLoginStatus(true, account['email']); // Simpan status login dan email ke memori lokal

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                );
              }).toList(),
                
                const SizedBox(height: 8),
                
                // Tambahkan Akun -> Masuk ke Register Page
                ListTile(
                  leading: const Icon(Icons.person_add_alt_1, color: Colors.black87),
                  title: const Text('Tambahkan akun lain', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                  onTap: () {
                    Navigator.pop(context); // Tutup dialog dulu
                    // Buka halaman Register dengan email kosong
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen(email: '')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}