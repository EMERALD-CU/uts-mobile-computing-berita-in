class AppData {
  // Menyimpan riwayat email yang pernah diketik
  static List<String> emailHistory = [];

  // Menyimpan daftar akun (dimuat dengan 2 akun default Anda)
  static List<Map<String, dynamic>> savedAccounts = [
    {
      'name': 'Emerald Alphante Reirezqi',
      'email': 'emeraldalphanter@gmail.com',
      'initial': 'M',
      'color': 0xFF4CAF50, // Warna hijau
    },
    {
      'name': 'Akun anonim',
      'email': 'anonimus12@gmail.com',
      'initial': 'A',
      'color': 0xFFFFC107, // Warna kuning/amber
    }
  ];
}