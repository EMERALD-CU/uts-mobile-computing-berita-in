import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class ApiService {
  static const String _apiKey = '7d581a0ff77441fb831259546364c6df'; 

  Future<List<Article>> fetchNews(String query) async {
    try {
      // URL akan otomatis berubah sesuai kata kunci pencarian (query)
      final String url = 'https://newsapi.org/v2/everything?q=$query&language=id&sortBy=publishedAt&apiKey=$_apiKey';
      
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List articlesJson = data['articles'];
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat berita dari server');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}