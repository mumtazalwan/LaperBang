import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Pages/detail_jajanan.dart';
import '../Services/jajan_provider.dart';

class PedagangPopUpCard extends StatefulWidget {
  final Map<String, dynamic> pedagangData;
  final VoidCallback onCallPressed;
  final VoidCallback onFollowPressed;

  const PedagangPopUpCard({
    super.key,
    required this.pedagangData,
    required this.onCallPressed,
    required this.onFollowPressed,
  });

  @override
  State<PedagangPopUpCard> createState() => _PedagangPopUpCardState();
}

class _PedagangPopUpCardState extends State<PedagangPopUpCard> {
  bool _isLoadingFollow = false;

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
    String vendorId =
        widget.pedagangData['id']?.toString() ??
        widget.pedagangData['vendor_id']?.toString() ??
        '';

    bool isLiked = provider.isFavorite(vendorId);

    bool isFollowing =
        provider.rutePoints.isNotEmpty &&
        provider.selectedVendor != null &&
        (provider.selectedVendor!['id']?.toString() ??
                provider.selectedVendor!['vendor_id']?.toString()) ==
            vendorId;

    String kategori = widget.pedagangData['kategori'] ?? 'Kategori';
    Color categoryColor = _getCategoryColor(kategori);
    IconData categoryIcon = _getCategoryIcon(kategori);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  height: 60.w,
                  width: 60.w,
                  color: categoryColor.withOpacity(0.15),
                  child: Icon(categoryIcon, color: categoryColor, size: 30.sp),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pedagangData['nama'] ?? 'Tanpa Nama',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      kategori,
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => provider.toggleFavorite(widget.pedagangData),
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          const Divider(height: 1, color: Colors.black12),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailJajanan(vendorData: widget.pedagangData),
                      ),
                    );
                  },
                  child: const Text('Detail'),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing ? Colors.red : Colors.blue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                  ),
                  onPressed: _isLoadingFollow
                      ? null
                      : () async {
                          setState(() {
                            _isLoadingFollow = true;
                          });

                          if (isFollowing) {
                            await provider.unfollowVendorApi(vendorId);
                            provider.stopFollowingVendor();

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Berhenti mengikuti pedagang.'),
                                ),
                              );
                            }
                          } else {
                            bool success = await provider.followVendorApi(
                              vendorId,
                            );
                            if (success) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Berhasil mengikuti & subscribe event!',
                                    ),
                                  ),
                                );
                                Future.delayed(
                                  const Duration(milliseconds: 100),
                                  () {
                                    widget.onFollowPressed();
                                  },
                                );
                              }
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Gagal mengikuti pedagang.'),
                                  ),
                                );
                              }
                            }
                          }

                          if (mounted) {
                            setState(() {
                              _isLoadingFollow = false;
                            });
                          }
                        },
                  child: _isLoadingFollow
                      ? SizedBox(
                          height: 16.sp,
                          width: 16.sp,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isFollowing ? Icons.cancel : Icons.directions,
                              size: 16.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              isFollowing ? 'Berhenti' : 'Ikuti',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                flex: 1,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                  ),
                  onPressed: () {
                    widget.onCallPressed();

                    String namaPedagang =
                        widget.pedagangData['nama'] ?? 'Tanpa Nama';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Sukses memberikan sinyal ke pedagang $namaPedagang',
                        ),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: Icon(Icons.campaign, size: 16.sp, color: Colors.white),
                  label: const Text(
                    'Panggil',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
