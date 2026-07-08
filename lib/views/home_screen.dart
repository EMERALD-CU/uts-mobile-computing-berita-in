import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';
import 'harian_page.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; 
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Beranda', 'Politik', 'Hukum', 'Ekonomi', 'Lingkungan', 'Teknologi', 'Olahraga', 'Hiburan'
  ];

  Widget _buildArticleCard(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFCEAE8), 
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
            child: const Icon(Icons.image, color: Colors.grey, size: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
              maxLines: 4, overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Widget Konten Beranda (Ada Artikel)
  Widget _buildBerandaContent() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ARTIKEL TERBARU', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 16),
            _buildArticleCard('4 Tentara Penyiram Air Keras ke Andrie Yunus Dituntut 2,5 Tahun Penjara'),
            _buildArticleCard('VCGamers Jadi Rumah bagi 25 Ribu Pelaku UMKM Digital di Indonesia'),
            _buildArticleCard('Perunding AS-Iran Sepakat Gencatan Snjata 60 Hari'),
            
            const SizedBox(height: 24),
            
            const Text('ARTIKEL TRENDING', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 16),
            _buildArticleCard('Makan Bergizi Masuk Sisdiknas'),
            _buildArticleCard('PPPK paruh waktu diperpanjang hingga tahun depan, gaji setara UMP'),
            _buildArticleCard('Babak Kedua Rangsangan Ekonomi'),
          ],
        ),
      ),
    );
  }

  // Widget Konten Kosong
  Widget _buildEmptyCategoryContent(String categoryName) {
    return Expanded(
      child: Container(
        color: Colors.white, 
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ARTIKEL $categoryName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBerandaPage() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            // Garis pembatas di bawah bilah kategori
            border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    const SizedBox(width: 8), 
                    for (int i = 0; i < _categories.length; i++)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = i; 
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _categories[i],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: _selectedCategoryIndex == i ? FontWeight.bold : FontWeight.normal,
                                  color: _selectedCategoryIndex == i ? AppColors.primaryRed : Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 2,
                                width: 40,
                                color: _selectedCategoryIndex == i ? AppColors.primaryRed : Colors.transparent,
                              )
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(width: 16), 
                  ],
                ),
              ),
              Positioned(
                left: 0, top: 0, bottom: 0,
                child: Container(
                  width: 24, 
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft, end: Alignment.centerRight,
                      colors: [Colors.white, Colors.white.withOpacity(0.0)],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0, top: 0, bottom: 0,
                child: Container(
                  width: 40, 
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight, end: Alignment.centerLeft,
                      colors: [Colors.white, Colors.white.withOpacity(0.0)],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        if (_selectedCategoryIndex == 0)
          _buildBerandaContent() 
        else
          _buildEmptyCategoryContent(_categories[_selectedCategoryIndex].toUpperCase()), 
      ],
    );
  }

  Widget _buildCurrentPage() {
    if (_selectedIndex == 0) {
      return _buildBerandaPage();
    } else if (_selectedIndex == 1) {
      return const HarianPage();
    } else {
      return const Center(child: Text('Halaman Berita.in Plus (Segera Hadir)'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, 
        title: const Text(
          'BERITA.IN',
          style: TextStyle(fontFamily: 'Gagalin', color: AppColors.primaryRed, fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: 1.0),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade300, // Mengubah warna dari shade200 ke shade300 agar batasan terlihat konstan
            height: 1.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black), 
            onPressed: () async {
              await AuthService.logout();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
            },
          ),
          IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      
      body: _buildCurrentPage(),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() { 
            _selectedIndex = index; 
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Harian'),
          BottomNavigationBarItem(icon: Icon(Icons.bento_outlined), label: 'Berita.in Plus'),
        ],
      ),
    );
  }
}