import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Services/jajan_provider.dart';

class DetailJajanan extends StatelessWidget {
  final Map<String, dynamic> vendorData;

  const DetailJajanan({super.key, required this.vendorData});

  final Color darkText = const Color(0xFF0F374A);
  final Color primaryRed = const Color(0xFFFF3B47);
  final Color primaryBlue = const Color(0xFF0E7DFF);
  final Color lightBlueCard = const Color(0xFFF2F8FB);
  final Color greyText = const Color(0xFF8A98A1);

  IconData _getCategoryIcon(String kategori) {
    if (kategori == 'Makanan Berat') return Icons.local_dining;
    if (kategori == 'Minuman') return Icons.local_drink;
    if (kategori == 'Cemilan') return Icons.tapas;
    return Icons.fastfood_outlined;
  }

  Color _getCategoryColor(String kategori) {
    if (kategori == 'Makanan Berat') return Colors.red;
    if (kategori == 'Minuman') return Colors.blue;
    if (kategori == 'Cemilan') return Colors.orange;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JajanProvider>();

    String currentId =
        vendorData['id']?.toString() ??
        vendorData['vendor_id']?.toString() ??
        '';
    bool isLiked = provider.isFavorite(currentId);

    String description =
        vendorData['description'] ?? 'Tidak ada deskripsi tersedia.';
    String startingPrice = vendorData['starting_price']?.toString() ?? '5000';
    String rating = vendorData['rating']?.toString() ?? '0.0';
    String kategori = vendorData['kategori'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios_new, color: darkText, size: 18.sp),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          vendorData['nama'] ?? 'Detail Jajanan',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
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
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: primaryBlue, width: 1.5),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: IconButton(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Menuju halaman chat...')),
                    );
                  },
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    color: primaryBlue,
                    size: 24.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  onPressed: () {
                    provider.selectVendor(vendorData);
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.navigation_outlined,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  label: Text(
                    'Mulai Navigasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(kategori),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: Icon(
                          _getCategoryIcon(kategori),
                          color: Colors.white,
                          size: 60.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            Icons.location_on_outlined,
                            '${vendorData['lokasi']?.latitude.toStringAsFixed(5) ?? "-"}, ${vendorData['lokasi']?.longitude.toStringAsFixed(5) ?? "-"}',
                          ),
                          SizedBox(height: 12.h),
                          _buildInfoRow(
                            Icons.directions_walk,
                            vendorData['jarak_meter'] != null
                                ? '${double.parse(vendorData['jarak_meter'].toString()).toStringAsFixed(0)} m'
                                : 'Jarak tidak diketahui',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: lightBlueCard,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mulai Dari:',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: darkText,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Rp$startingPrice',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 40.h,
                        width: 1.w,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rating',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: darkText,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  rating,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: darkText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => provider.toggleFavorite(vendorData),
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: primaryRed,
                          size: 24.sp,
                        ),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Deskripsi',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                SizedBox(height: 8.h),
                ExpandableDescription(
                  text: description,
                  primaryBlue: primaryBlue,
                  greyText: greyText,
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Review Pembeli',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),
                    Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16.r,
                            backgroundColor: Colors.orange.shade200,
                            child: Icon(
                              Icons.person,
                              size: 20.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Budi Santoso',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: darkText,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.star, color: Colors.amber, size: 16.sp),
                          Text(
                            ' 4.8',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '"Beneran segar dan enak, manisnya pas asli bukan pemanis buatan. Abangnya juga bersih dan ramah. Mantap!"',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: greyText,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: primaryBlue, size: 20.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14.sp, color: darkText),
          ),
        ),
      ],
    );
  }
}

class ExpandableDescription extends StatefulWidget {
  final String text;
  final Color primaryBlue;
  final Color greyText;

  const ExpandableDescription({
    super.key,
    required this.text,
    required this.primaryBlue,
    required this.greyText,
  });

  @override
  State<ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  bool isExpanded = false;
  final int maxLength = 100;

  @override
  Widget build(BuildContext context) {
    if (widget.text.length <= maxLength) {
      return Text(
        widget.text,
        style: TextStyle(fontSize: 14.sp, color: widget.greyText, height: 1.5),
      );
    }

    String displayText = isExpanded
        ? '${widget.text} '
        : '${widget.text.substring(0, maxLength)}... ';
    String actionText = isExpanded
        ? 'Tampilkan lebih sedikit'
        : 'Baca lengkapnya...';

    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 14.sp,
            color: widget.greyText,
            height: 1.5,
          ),
          children: [
            TextSpan(text: displayText),
            TextSpan(
              text: actionText,
              style: TextStyle(
                color: widget.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
