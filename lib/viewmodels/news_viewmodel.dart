import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/api_service.dart';

// ChangeNotifier adalah bawaan Flutter agar class ini bisa dipantau oleh Provider
class NewsViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Tempat menyimpan status
  List<Article> _articles = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Pengambil data (Getters) agar bisa dibaca oleh UI
  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchTopNews({String category = 'Indonesia'}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Jika yang diklik adalah 'Beranda', cari berita umum (Indonesia).
      // Jika bukan, cari sesuai nama kategorinya (misal: 'Politik', 'Hukum')
      String searchQuery = (category == 'Beranda') ? 'Indonesia' : category;
      
      // Kirim kata kunci ke ApiService
      _articles = await _apiService.fetchNews(searchQuery);
    } catch (e) {
      _errorMessage = 'Gagal mengambil berita. Pastikan internet Anda aktif.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}