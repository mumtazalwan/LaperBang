import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_constants.dart';

class CustomFloatingSearchBar extends StatelessWidget {
  final List<Map<String, dynamic>> listJajanan;
  final Function(Map<String, dynamic>) onSelected;
  final bool autoFocus;

  const CustomFloatingSearchBar({
    super.key,
    required this.listJajanan,
    required this.onSelected,
    required this.autoFocus,
  });

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Autocomplete<Map<String, dynamic>>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<Map<String, dynamic>>.empty();
          }
          return listJajanan.where((jajanan) {
            return jajanan['nama'].toString().toLowerCase().contains(textEditingValue.text.toLowerCase());
          });
        },
        displayStringForOption: (Map<String, dynamic> option) => option['nama'],
        onSelected: (Map<String, dynamic> selection) {
          onSelected(selection);
        },
        optionsViewBuilder: (context, onSelectedOption, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.sizeOf(context).width - 40.w,
                constraints: BoxConstraints(maxHeight: 260.h),
                margin: EdgeInsets.only(top: 4.h),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 8))],
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Map<String, dynamic> option = options.elementAt(index);
                    String kategori = option['kategori'] ?? 'Kategori';
                    Color catColor = _getCategoryColor(kategori);

                    return InkWell(
                      onTap: () => onSelectedOption(option),
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        margin: EdgeInsets.only(bottom: index == options.length - 1 ? 0 : 8.h),
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 45.w,
                              height: 45.w,
                              decoration: BoxDecoration(color: catColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10.r)),
                              child: Icon(_getCategoryIcon(kategori), size: 22.sp, color: catColor),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    option['nama'] ?? 'Tanpa Nama',
                                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: const Color(0xFF0F374A)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(kategori, style: TextStyle(fontSize: 12.sp, color: const Color(0xFF8A98A1))),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey.shade400),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
        fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
          return TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: autoFocus,
            decoration: InputDecoration(
              hintText: "Mau jajan apa hari ini?",
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(AppSizes.sm),
            ),
          );
        },
      ),
    );
  }
}