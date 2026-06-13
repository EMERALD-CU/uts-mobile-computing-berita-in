# BERITA.IN - Mobile Computing App

Aplikasi berita digital komprehensif yang dikembangkan menggunakan Flutter. Proyek ini merupakan hasil *slicing* UI/UX dari Figma menjadi aplikasi *mobile* interaktif untuk memenuhi tugas Ujian Tengah Semester (UTS).

## Tautan Desain
🔗 **Figma Design:** (https://www.figma.com/design/8HtUj97GvAGqRKqwtyTNcr/BERITA.IN?node-id=0-1&p=f&t=G5vPJmMBo0ruyNuy-0)

## Fitur Utama (*Slicing & State Management*)
Proyek ini mengimplementasikan struktur navigasi dan antarmuka yang dinamis:
* **Autentikasi:** Halaman Login dan Register dengan validasi *form* interaktif (RegExp untuk Email, pencocokan *password*, dan kontrol UI *checkbox* persetujuan).
* **Navigasi Utama:** *Bottom Navigation Bar* yang menukar layar tanpa kehilangan *state* sebelumnya.
* **Beranda Kategori:** Sistem *tab* kategori horizontal dengan efek *fade gradient* dan perubahan *state* konten yang menyesuaikan kategori yang dipilih secara *real-time*.
* **Pencarian Harian:** Halaman arsip berita dengan fitur kalender (`showDatePicker`) yang telah disesuaikan temanya, lengkap dengan *empty state logic* jika berita pada tanggal tertentu tidak tersedia.
* **Kustomisasi Visual:** Implementasi *custom font* (Gagalin) dan integrasi aset gambar.

## Struktur Direktori Utama
* `lib/screens/` - Berisi seluruh *file* UI halaman aplikasi (Login, Register, Home, Harian).
* `lib/widgets/` - Komponen UI yang dapat digunakan kembali (*reusable*), seperti tombol dan *text field*.
* `lib/theme/` - Pengaturan palet warna utama aplikasi.
* `assets/fonts/` - Penyimpanan *file* *custom font*.

---
*Dibuat oleh Emerald Alphante Reirezqi.*