import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laperbang/Pages/login_page.dart';
import 'package:provider/provider.dart';
import '../Services/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  final Color darkText = const Color(0xFF0F374A);
  final Color greyText = const Color(0xFF8A98A1);
  final Color primaryBlue = const Color(0xFF0E7DFF);
  final Color primaryRed = const Color(0xFFFF3B47);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    String fullName = user?.name ?? 'Memuat...';
    String email = user?.email ?? 'Memuat...';
    String username = user?.username ?? 'Memuat...';

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              }
            },
            child: Container(
              width: double.infinity,
              height: 55.h,
              decoration: BoxDecoration(
                color: primaryRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: primaryRed.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: primaryRed, size: 22.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: primaryRed,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35.r,
                      backgroundColor: primaryBlue.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        size: 40.sp,
                        color: primaryBlue,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                fullName,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: darkText,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(
                                Icons.edit_outlined,
                                color: greyText,
                                size: 18.sp,
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            email,
                            style: TextStyle(fontSize: 14.sp, color: greyText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Divider(color: Colors.grey.shade200, thickness: 1.h, height: 1),
              _buildEditableListItem(
                icon: Icons.person_outline,
                title: 'Nama Lengkap',
                value: fullName,
                onTap: () {},
              ),
              Divider(color: Colors.grey.shade200, thickness: 1.h, height: 1),
              _buildEditableListItem(
                icon: Icons.alternate_email,
                title: 'Username',
                value: username,
                onTap: () {},
              ),
              Divider(color: Colors.grey.shade200, thickness: 1.h, height: 1),
              _buildEditableListItem(
                icon: Icons.email_outlined,
                title: 'Email',
                value: email,
                onTap: () {},
              ),
              Divider(color: Colors.grey.shade200, thickness: 1.h, height: 1),
              _buildEditableListItem(
                icon: Icons.lock_outline,
                title: 'Password',
                value: '••••••••',
                onTap: () {},
              ),
              Divider(color: Colors.grey.shade200, thickness: 1.h, height: 1),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableListItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(icon, color: darkText, size: 24.sp),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 14.sp, color: greyText),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: darkText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: darkText, size: 24.sp),
          ],
        ),
      ),
    );
  }
}
