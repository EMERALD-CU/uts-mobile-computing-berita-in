import 'plus_page.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';
import 'harian_page.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';
import '../viewmodels/news_viewmodel.dart';
import 'article_detail_screen.dart';
import '../services/api_service.dart';
import '../models/article_model.dart';

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

// Widget Konten Beranda (Ada Artikel dari API)
  Widget _buildBerandaContent() {
    return Expanded(
      child: Consumer<NewsViewModel>(
        builder: (context, viewModel, child) {
          // 1. Tampilkan loading warna merah khas aplikasi Anda
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryRed),
            );
          }

          // 2. Tampilkan pesan error jika internet mati
          if (viewModel.errorMessage.isNotEmpty) {
            return Center(child: Text(viewModel.errorMessage));
          }

          // 3. Tampilkan pesan jika berita kosong
          if (viewModel.articles.isEmpty) {
            return const Center(child: Text('Belum ada berita hari ini.'));
          }

          // 4. Render tampilan berita API dengan desain orisinal Anda
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ARTIKEL ${_selectedCategoryIndex == 0 ? "TERBARU" : _categories[_selectedCategoryIndex].toUpperCase()}', 
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)
                ),
                const SizedBox(height: 16),
                
                // Looping data berita dari internet
                ListView.builder(
                  shrinkWrap: true, // Wajib agar tidak bentrok dengan SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: viewModel.articles.length,
                  itemBuilder: (context, index) {
                    final article = viewModel.articles[index];
                    
                    return GestureDetector(
                      onTap: () {
                        // Perintah untuk pindah halaman dengan membawa data 'article'
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDetailScreen(article: article),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCEAE8), 
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2), 
                              spreadRadius: 1, 
                              blurRadius: 4, 
                              offset: const Offset(0, 2)
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Gambar Artikel dari Internet
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                article.imageUrl,
                                width: 100, 
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 100, 
                                  height: 100,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.image, color: Colors.grey, size: 40),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Judul Artikel
                            Expanded(
                              child: Text(
                                article.title,
                                style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
                                maxLines: 4, 
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
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
                          Provider.of<NewsViewModel>(context, listen: false)
                              .fetchTopNews(category: _categories[i]);
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
        
        _buildBerandaContent(),
      ],
    );
  }

  Widget _buildCurrentPage() {
    if (_selectedIndex == 0) {
      return _buildBerandaPage();
    } else if (_selectedIndex == 1) {
      return const HarianPage();
    } else {
      return const PlusPage();
    }
  }

  @override
  void initState() {
    super.initState();
    // Perintah untuk memanggil API News segera setelah layar selesai digambar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsViewModel>(context, listen: false).fetchTopNews();
    });
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
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black), 
            onPressed: () {
              // Membuka halaman overlay pencarian bawaan Flutter
              showSearch(
                context: context,
                delegate: NewsSearchDelegate(),
              );
            },
          ),
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
        items: [
           const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Beranda'),
           const BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Harian'),
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/images/logo_b_grey.jpeg',  width: 20, height: 20, fit: BoxFit.cover),
            activeIcon: Image.asset('lib/assets/images/logo_b.jpeg',  width: 20, height: 20, fit: BoxFit.cover),
            label: 'Berita.in Plus'),
        ],
      ),
    );
  }
}
// --- CLASS BARU UNTUK MENANGANI PENCARIAN ---
class NewsSearchDelegate extends SearchDelegate {
  
  // 1. Tombol aksi di sebelah kanan (Tombol Clear/Hapus teks)
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.black),
        onPressed: () {
          query = ''; // Mengosongkan kolom ketik pencarian
        },
      ),
    ];
  }

  // 2. Tombol aksi di sebelah kiri (Tombol Kembali)
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () {
        close(context, null); // Menutup halaman pencarian
      },
    );
  }

  // 3. Tampilan saat user menekan tombol "Search" di keyboard HP
  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return const Center(child: Text('Ketik kata kunci pencarian...'));
    }

    return FutureBuilder<List<Article>>(
      future: ApiService().fetchNews(query), // Mencari berita berdasarkan teks 'query'
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.red),
          );
        }
        
        if (snapshot.hasError) {
          return const Center(child: Text('Gagal memuat hasil pencarian.'));
        }

        final articles = snapshot.data ?? [];
        if (articles.isEmpty) {
          return const Center(child: Text('Berita tidak ditemukan.'));
        }

        // Tampilkan daftar hasil pencarian
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailScreen(article: article),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCEAE8), 
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2), 
                      spreadRadius: 1, 
                      blurRadius: 4, 
                      offset: const Offset(0, 2)
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        article.imageUrl,
                        width: 100, 
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 100, 
                          height: 100,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image, color: Colors.grey, size: 40),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        article.title,
                        style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
                        maxLines: 4, 
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 4. Tampilan rekomendasi saat user baru mulai mengetik
  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text(
        'Cari berita terbaru di BERITA.IN...',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}