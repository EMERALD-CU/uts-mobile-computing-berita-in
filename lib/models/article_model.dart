class Article {
  final String title;
  final String description;
  final String imageUrl;
  final String content;

  Article({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.content,
  });

  
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      // Jika data dari API kosong (null), kita beri nilai default agar aplikasi tidak error
      title: json['title'] ?? 'Tanpa Judul',
      description: json['description'] ?? 'Tidak ada deskripsi singkat.',
      imageUrl: json['urlToImage'] ?? 'https://via.placeholder.com/400x200?text=No+Image',
      content: json['content'] ?? 'Konten tidak tersedia.',
    );
  }
}