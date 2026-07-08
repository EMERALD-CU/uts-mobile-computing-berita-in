import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HarianPage extends StatefulWidget {
  const HarianPage({Key? key}) : super(key: key);

  @override
  State<HarianPage> createState() => _HarianPageState();
}

class _HarianPageState extends State<HarianPage> {
  DateTime _selectedDate = DateTime(2026, 5, 27);

  String _formatDate(DateTime date) {
    const List<String> monthNames = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate, 
      firstDate: DateTime(2000),  
      lastDate: DateTime(2100),   
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryRed, 
              onPrimary: Colors.white,       
              onSurface: Colors.black,       
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryRed, 
              ),
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
    }
  }

  Widget _buildHarianCard(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFD28E8B), 
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 140,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
            ),
            child: const Icon(Icons.image, color: Colors.white70, size: 50),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET UNTUK TAMPILAN KOSONG ---
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 48.0),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'Belum ada berita',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              'Edisi ${_formatDate(_selectedDate)} belum tersedia.',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengecek apakah tanggal yang dipilih adalah 27 Mei 2026
    bool isDataAvailable = _selectedDate.year == 2026 && _selectedDate.month == 5 && _selectedDate.day == 27;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'HARIAN',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 16),
          const Text(
            'Berita harian ini hadir untuk memudahkan\npencarian berita berdasarkan waktu tertentu.',
            style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
          ),
          const SizedBox(height: 24),
          
          const Text('Pilih edisi harian lainnya', style: TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 8),
          
          GestureDetector(
            onTap: () => _selectDate(context), 
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.transparent, 
                border: Border.all(color: Colors.black87),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(_selectedDate), 
                    style: const TextStyle(fontSize: 16, color: Colors.black87)
                  ),
                  const Icon(Icons.calendar_today, color: Colors.black87),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // --- LOGIKA PENGKONDISIAN TAMPILAN ---
          if (isDataAvailable) ...[
            // Tampilkan berita jika tanggal sesuai (27 Mei 2026)
            _buildHarianCard('Presiden Prabowo Sumbang Sapi Kurban Rp 100 M Pakai APBN, Purbaya Tak Tahu'),
            _buildHarianCard('Prabowo Beli Sapi Kurban Pakai Dana APBN, Ini Tanggapan MUI'),
            _buildHarianCard('Gempa Dahsyat Yogyakarta hingga Lumpur Lapindo Genangi Sidoarjo'),
          ] else ...[
            // Tampilkan layar kosong jika tanggal lain yang dipilih
            _buildEmptyState(),
          ]
        ],
      ),
    );
  }
}