import '../data/app_data.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class PlusPage extends StatefulWidget {
  const PlusPage({super.key});

  @override
  State<PlusPage> createState() => _PlusPageState();
}

class _PlusPageState extends State<PlusPage> {
  XFile? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _bukaKamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _profileImage = image;
        });
      }
    } catch (e) {
      debugPrint("Gagal membuka kamera: $e");
    }
  }

  String _namaAkun = 'Memuat...';

  @override
  void initState() {
    super.initState();
    _ambilDataPengguna();
  }

  Future<void> _ambilDataPengguna() async {
    String? emailLogin = await AuthService.getUserEmail();
    if (emailLogin != null) {
      String namaDitemukan = emailLogin; 
      
      for (var akun in AppData.savedAccounts) {
        if (akun['email'] == emailLogin) {
          namaDitemukan = akun['name'];
          break;
        }
      }
      
      setState(() {
        _namaAkun = namaDitemukan;
      });
    }
  }

  // Fungsi simulasi saat fitur premium ditekan
  void _tampilkanDialogFitur(String namaFitur) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(namaFitur),
        content: Text('Fitur "$namaFitur" sedang dalam tahap pengembangan. Nantikan pembaruannya segera!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

 @override
  Widget build(BuildContext context) {
    // Mengambil tinggi status bar ponsel agar jarak atas pas di semua jenis HP
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // --- 1. KARTU PROFIL ---
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: topPadding + 24, bottom: 28, left: 24, right: 24),
              decoration: const BoxDecoration(
                color: Color(0xFFE0A7A7), 
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar Interaktif dengan Indikator Kamera yang Lebih Rapi
                  GestureDetector(
                    onTap: _bukaKamera,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.black87, width: 2),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6),
                            ],
                            image: _profileImage != null
                                ? DecorationImage(
                                    image: kIsWeb 
                                        ? NetworkImage(_profileImage!.path) 
                                        : FileImage(File(_profileImage!.path)) as ImageProvider,
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _profileImage == null 
                              ? const Icon(Icons.person_outline, size: 38, color: Colors.black87) 
                              : null,
                        ),
                        // Lingkaran Kecil Ikon Kamera
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.black87,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, size: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _namaAkun,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Verified Account',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- AREA KONTEN UTAMA ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // --- 2. PREMIUM FEATURES ---
                  const Text(
                    'Premium Features',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _tampilkanDialogFitur('AI Summaries'),
                          child: _buildPremiumCard(
                            icon: Icons.auto_awesome_outlined, 
                            title: 'AI Summaries', 
                            iconColor: Colors.blue.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _tampilkanDialogFitur('Remove Ads'),
                          child: _buildPremiumCard(
                            icon: Icons.block_outlined, 
                            title: 'Remove Ads', 
                            iconColor: Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // --- 3. BANNER KONTRIBUTOR ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    decoration: BoxDecoration(
                      // Gradasi warna lembut agar terlihat seperti spanduk premium
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFCF3F3), Color(0xFFF9E4E4)], 
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.withOpacity(0.15), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Ikon Pena/Dokumen Menonjol
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.red.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 6)),
                            ],
                          ),
                          child: const Icon(Icons.edit_document, size: 36, color: AppColors.primaryRed),
                        ),
                        const SizedBox(height: 20),
                        
                        // Judul Menggugah
                        const Text(
                          'Punya Perspektif Menarik?',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 12),
                        
                        // Teks Deskripsi
                        const Text(
                          'Jadilah kontributor Berita.in. Bagikan opini Anda dan jangkau ribuan pembaca setia setiap harinya.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, height: 1.5, color: Colors.black54),
                        ),
                        const SizedBox(height: 28),
                        
                        // Tombol Utama "Mulai Menulis"
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _tampilkanDialogFitur('Mulai Menulis Artikel'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              elevation: 3, // Bayangan tombol agar menonjol
                              shadowColor: AppColors.primaryRed.withOpacity(0.4),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text(
                              'Mulai Menulis Sekarang',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // --- 4. TOMBOL KELUAR AKUN ---
                  Center(
                    child: TextButton.icon(
                      onPressed: () async {
                        await AuthService.logout();
                        Navigator.pushAndRemoveUntil(
                          context, 
                          MaterialPageRoute(builder: (context) => const LoginScreen()), 
                          (route) => false
                        );
                      },
                      icon: const Icon(Icons.logout_rounded, color: Colors.grey, size: 18),
                      label: const Text(
                        'Keluar dari Akun', 
                        style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPremiumCard({required IconData icon, required String title, required Color iconColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: iconColor),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}