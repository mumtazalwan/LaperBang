import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Services/auth_provider.dart';
import '../Widgets/auth_widgets.dart';
import 'register.dart';
import 'main_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                    height: 1.3,
                  ),
                  children: [
                    const TextSpan(
                      text: "Jajan gampang, perut kenyang. Mulai dari ",
                    ),
                    TextSpan(
                      text: "LaperBang.",
                      style: TextStyle(color: primaryBlue),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              Text(
                "Sign In",
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
              SizedBox(height: 40.h),

              AuthTextField(
                controller: _emailController,
                label: "Email",
                hint: "Masukkan email anda",
                suffixIcon: Icons.check,
                suffixColor: Colors.green,
              ),
              SizedBox(height: 25.h),
              AuthTextField(
                controller: _passwordController,
                label: "Password",
                hint: "••••••••",
                isPassword: true,
                obscureText: !authProvider.isPasswordVisible,
                onToggleVisibility: () =>
                    authProvider.togglePasswordVisibility(),
              ),
              SizedBox(height: 50.h),

              PrimaryButton(
                label: authProvider.isLoading ? "Loading..." : "Sign in",
                onPressed: () async {
                  if (authProvider.isLoading) return;

                  if (_emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Harap isi email dan password.'),
                      ),
                    );
                    return;
                  }

                  bool success = await authProvider.login(
                    _emailController.text,
                    _passwordController.text,
                  );

                  if (success) {
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Login gagal. Periksa kembali email atau password Anda.',
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 30.h),

              Center(
                child: Column(
                  children: [
                    Text(
                      "Belum memiliki akun?",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: darkText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
