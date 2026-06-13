import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Services/auth_provider.dart';
import '../Widgets/auth_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    const Color darkText = Color(0xFF0F374A);
    const Color primaryBlue = Color(0xFF0E7DFF);
    const Color greyText = Color(0xFF8A98A1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: darkText, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                    height: 1.3,
                  ),
                  children: [
                    const TextSpan(
                      text: "Nyari jajanan nggak perlu nunggu lewat. Buka ",
                    ),
                    TextSpan(
                      text: "LaperBang",
                      style: TextStyle(color: primaryBlue),
                    ),
                    const TextSpan(text: ", langsung sikat!"),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              Text(
                "Masukkan Kredensial Anda",
                style: TextStyle(fontSize: 14.sp, color: greyText),
              ),
              SizedBox(height: 30.h),

              AuthTextField(
                controller: _usernameController,
                label: "Username",
                hint: "Masukkan username unik",
                suffixIcon: Icons.person_outline,
                suffixColor: greyText,
              ),
              SizedBox(height: 20.h),
              AuthTextField(
                controller: _nameController,
                label: "Nama Lengkap",
                hint: "Masukkan nama sesuai KTP",
                suffixIcon: Icons.check,
                suffixColor: Colors.green,
              ),
              SizedBox(height: 20.h),
              AuthTextField(
                controller: _emailController,
                label: "Email",
                hint: "Masukkan email aktif",
                suffixIcon: Icons.check,
                suffixColor: Colors.green,
              ),
              SizedBox(height: 20.h),
              AuthTextField(
                controller: _passwordController,
                label: "Password",
                hint: "••••••••",
                isPassword: true,
                obscureText: !authProvider.isPasswordVisible,
                onToggleVisibility: () =>
                    authProvider.togglePasswordVisibility(),
              ),
              SizedBox(height: 20.h),

              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: greyText,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                      text: "Dengan melanjutkan, anda menyetujui ",
                    ),
                    TextSpan(
                      text: "Syarat dan Ketentuan",
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: " serta "),
                    TextSpan(
                      text: "Kebijakan Privasi",
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: " kami."),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              PrimaryButton(
                label: authProvider.isLoading ? "Loading..." : "Sign up",
                onPressed: () async {
                  if (authProvider.isLoading) return;

                  if (_usernameController.text.isEmpty ||
                      _nameController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Harap isi semua data dengan lengkap.'),
                      ),
                    );
                    return;
                  }

                  bool success = await authProvider.register(
                    username: _usernameController.text,
                    name: _nameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                  );

                  if (success) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registrasi berhasil! Silakan login.'),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Registrasi gagal. Cek kembali data atau jaringan Anda.',
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
