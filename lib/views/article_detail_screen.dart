import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../theme/app_colors.dart';

class ArticleDetailScreen extends StatelessWidget {
  // Variabel penampung data berita yang dikirim dari Home
  final Article article;

  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Tombol kembali otomatis berwarna hitam
        iconTheme: const IconThemeData(color: Colors.black), 
        title: const Text(
          'Detail Berita',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Gambar Utama Penuh
            Image.network(
              article.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
              ),
            ),
            
            // 2. Konten Teks
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Garis Pembatas Estetik Merah
                  Container(width: 50, height: 4, color: AppColors.primaryRed),
                  const SizedBox(height: 16),
                  
                  // Deskripsi Singkat (Italic)
                  Text(
                    article.description,
                    style: TextStyle(
                      fontSize: 14, 
                      fontStyle: FontStyle.italic, 
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Isi Berita (Content)
                  Text(
                    article.content,
                    style: const TextStyle(
                      fontSize: 14, 
                      color: Colors.black, 
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}