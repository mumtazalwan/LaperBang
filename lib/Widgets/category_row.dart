import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow({Key? key}) : super(key: key);

  Widget _buildCategoryItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, color: Colors.blue, size: 28.w),
          ),
          SizedBox(height: 8.h),
          Text(title, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCategoryItem(icon: Icons.rice_bowl, title: "Berat", onTap: () {}),
        _buildCategoryItem(icon: Icons.local_drink, title: "Minuman", onTap: () {}),
        _buildCategoryItem(icon: Icons.fastfood, title: "Cemilan", onTap: () {}),
        _buildCategoryItem(icon: Icons.icecream, title: "Manis", onTap: () {}),
      ],
    );
  }
}