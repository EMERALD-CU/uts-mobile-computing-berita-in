import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../theme/app_colors.dart';
import '../widgets/google_sign_in_dialog.dart';
import '../widgets/primary_button.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  String _currentEmail = '';

void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final email = _currentEmail.trim();
      
      // Simpan riwayat email
      if (email.isNotEmpty && !AppData.emailHistory.contains(email)) {
        AppData.emailHistory.add(email);
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterScreen(email: email)),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'BERITA.IN',
          style: TextStyle(
            fontFamily: 'Gagalin',
            color: AppColors.primaryRed,
            fontSize: 30,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade200,
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Masuk atau Daftar',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Gunakan layanan di bawah ini untuk\nmasuk ke BERITA.IN Digital.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                ),
                const SizedBox(height: 32),

                OutlinedButton(
                  // 2. Memanggil fungsi dari google_sign_in_dialog.dart yang baru
                  onPressed: () => showGoogleSignInDialog(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.black87),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png',
                        height: 24,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Lanjutkan dengan Google',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                const Center(
                  child: Text('Atau', style: TextStyle(color: Colors.black54, fontSize: 16)),
                ),
                const SizedBox(height: 32),

                const Text(
                  'Masuk/Daftar menggunakan email anda',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Email',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 8),

                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') return const Iterable<String>.empty();
                    return AppData.emailHistory.where((String option) => 
                      option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                  },
                  onSelected: (String selection) {
                    _currentEmail = selection;
                  },
                  fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => _currentEmail = value,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Email tidak boleh kosong';
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Format email tidak valid';
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Masukan email akun anda',
                        hintStyle: const TextStyle(color: Colors.black54),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.black87)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.black)),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                PrimaryButton(
                  text: 'Lanjutkan',
                  onPressed: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
