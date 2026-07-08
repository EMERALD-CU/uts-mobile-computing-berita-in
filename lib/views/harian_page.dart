import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/news_viewmodel.dart';
import 'article_detail_screen.dart';

class HarianPage extends StatefulWidget {
  const HarianPage({super.key});

  @override
  State<HarianPage> createState() => _HarianPageState();
}

class _HarianPageState extends State<HarianPage> {
  // Variabel untuk menyimpan tanggal yang dipilih (default: hari ini)
  DateTime _selectedDate = DateTime.now(); 

  // Fungsi bawaan Flutter untuk memunculkan kalender
  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020), // Batas tahun paling bawah
      lastDate: DateTime.now(),  // Batas tahun paling atas (hari ini)
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.red, // Warna header kalender khas BERITA.IN
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });

      // 1. Format tanggal menjadi YYYY-MM-DD sesuai standar server NewsAPI
      String formattedDate = 
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

      // 2. Perintahkan Provider untuk menarik data baru berdasarkan tanggal tersebut
      Provider.of<NewsViewModel>(context, listen: false)
          .fetchTopNews(category: 'Indonesia', date: formattedDate);
    }
  }

  // Fungsi sederhana untuk mengubah format tanggal ke Bahasa Indonesia
  String _formatTanggal(DateTime date) {
    List<String> bulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${bulan[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Teks (Sesuai Figma)
          const Text(
            'HARIAN',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8),
          const Text(
            'Berita harian ini hadir untuk memudahkan pencarian berita berdasarkan waktu tertentu.',
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
          ),
          const SizedBox(height: 24),
          
          const Text(
            'Pilih edisi harian lainnya',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          
          // 2. Tombol Pemilih Tanggal (Date Picker)
          GestureDetector(
            onTap: () => _pilihTanggal(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatTanggal(_selectedDate),
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 3. Daftar Berita (Dibatasi Maksimal 7 Berita)
          Consumer<NewsViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(color: Colors.red),
                ));
              }

              if (viewModel.errorMessage.isNotEmpty) {
                return Center(child: Text(viewModel.errorMessage));
              }

              // --- LOGIKA PEMBATASAN MAKSIMAL 7 BERITA ---
              final semuaBerita = viewModel.articles;
              final jumlahTampil = semuaBerita.length > 7 ? 7 : semuaBerita.length;

              if (jumlahTampil == 0) {
                return const Center(child: Text('Belum ada berita untuk hari ini.'));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: jumlahTampil, // <--- Memakai jumlahTampil (Maksimal 7)
                itemBuilder: (context, index) {
                  final article = semuaBerita[index];
                  
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
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Lapisan Bawah: Gambar Berita Penuh
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              article.imageUrl,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: double.infinity,
                                height: 200,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              ),
                            ),
                          ),
                          
                          // Lapisan Atas: Kotak Putih dengan Judul Berita
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(4),
                              // Garis aksen biru di sisi kiri sesuai desain Figma Anda
                              border: const Border(
                                left: BorderSide(color: Colors.blue, width: 4), 
                              ),
                            ),
                            child: Text(
                              article.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}