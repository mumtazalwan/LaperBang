import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Services/jajan_provider.dart';
import 'detail_jajanan.dart';

class FavoriteVendors extends StatefulWidget {
  const FavoriteVendors({super.key});

  @override
  State<FavoriteVendors> createState() => _FavoriteVendorsState();
}

class _FavoriteVendorsState extends State<FavoriteVendors> {
  final Color darkText = const Color(0xFF0F374A);
  final Color primaryBlue = const Color(0xFF0E7DFF);
  final Color greyText = const Color(0xFF8A98A1);
  final Color lightGreyBg = const Color(0xFFF5F7F9);

  final List<String> _categories = [
    'Semua',
    'Makanan Berat',
    'Cemilan',
    'Minuman',
  ];
  int _selectedCategoryIndex = 0;

  // --- Fungsi Bantuan untuk UI Otomatis ---
  IconData _getIconData(String kategori) {
    if (kategori == 'Makanan Berat') return Icons.local_dining;
    if (kategori == 'Minuman') return Icons.local_drink;
    if (kategori == 'Cemilan') return Icons.tapas;
    return Icons.fastfood;
  }

  Color _getIconBgColor(String kategori) {
    if (kategori == 'Makanan Berat') return Colors.red.shade100;
    if (kategori == 'Minuman') return Colors.blue.shade100;
    if (kategori == 'Cemilan') return Colors.orange.shade100;
    return Colors.grey.shade200;
  }

  Color _getIconColor(String kategori) {
    if (kategori == 'Makanan Berat') return Colors.red.shade700;
    if (kategori == 'Minuman') return Colors.blue.shade700;
    if (kategori == 'Cemilan') return Colors.orange.shade700;
    return Colors.grey.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JajanProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20.w,
        title: Text(
          'Jajanan Favorit',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 12.w),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryBlue : lightGreyBg,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _categories[index],
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected ? Colors.white : greyText,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: provider.isDbLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.favoriteData.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada jajanan favorit',
                      style: TextStyle(fontSize: 14.sp, color: greyText),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: provider.favoriteData.length,
                    itemBuilder: (context, index) {
                      final item = provider.favoriteData[index];

                      // ⭐️ PERBAIKAN: Berikan nilai default yang aman jika data tidak ada di database lokal
                      final String nama = item['nama'] ?? 'Tanpa Nama';
                      final String kategori = item['kategori'] ?? 'Lainnya';
                      final String ratingStr =
                          item['rating']?.toString() ?? '-';
                      final String jarakStr =
                          item['jarak']?.toString() ?? '- km';

                      if (_selectedCategoryIndex != 0 &&
                          kategori != _categories[_selectedCategoryIndex]) {
                        return const SizedBox.shrink();
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailJajanan(vendorData: item),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 16.h),
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 80.w,
                                height: 80.w,
                                decoration: BoxDecoration(
                                  // ⭐️ PERBAIKAN: Gunakan fungsi otomatis, jangan memanggil item['color']
                                  color: _getIconBgColor(kategori),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  _getIconData(kategori),
                                  size: 40.sp,
                                  color: _getIconColor(kategori),
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nama,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: darkText,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      kategori,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: greyText,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          ratingStr,
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                            color: darkText,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                          ),
                                          child: Text(
                                            '•',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: greyText,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: greyText,
                                          size: 14.sp,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          jarakStr,
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: greyText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => provider.toggleFavorite(item),
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 26.sp,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
