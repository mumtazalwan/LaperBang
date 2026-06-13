import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import '../Widgets/category_row.dart';
import '../Widgets/promo_slider.dart';
import '../app_constants.dart';
import '../Services/jajan_provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  final Color darkText = const Color(0xFF0F374A);
  final Color primaryBlue = const Color(0xFF0E7DFF);

  IconData _getMarkerIcon(String kategori) {
    if (kategori == 'Makanan Berat') return Icons.local_dining;
    if (kategori == 'Minuman') return Icons.local_drink;
    if (kategori == 'Cemilan') return Icons.tapas;
    return Icons.fastfood_outlined;
  }

  Color _getMarkerColor(String kategori) {
    if (kategori == 'Makanan Berat') return Colors.red;
    if (kategori == 'Minuman') return Colors.blue;
    if (kategori == 'Cemilan') return Colors.orange;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JajanProvider>();

    List<Map<String, dynamic>> objekDalamRadius = [];
    if (provider.currentPosition != null) {
      const distanceCalc = Distance();
      objekDalamRadius = provider.objekSekitar.where((objek) {
        double jarak = distanceCalc.distance(
          provider.currentPosition!,
          objek['lokasi'],
        );
        return jarak <= 5000.0;
      }).toList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: AppSizes.paddingX,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: primaryBlue.withOpacity(0.1),
              child: Icon(
                Icons.person_outline,
                color: primaryBlue,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              "Hi Axel",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: darkText,
              size: 24.sp,
            ),
            onPressed: () {},
          ),
          SizedBox(width: AppSizes.paddingX),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.sm),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingX),
              child: GestureDetector(
                onTap: () => provider.goToMapAndSearch(),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppSizes.sm),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.sm),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey.shade500),
                        const SizedBox(width: 8),
                        Text(
                          "Mau jajan apa hari ini?",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSizes.xl - 8),
            const PromoSlider(),
            SizedBox(height: AppSizes.xl - 8),
            Padding(
              padding: EdgeInsets.all(AppSizes.paddingX),
              child: const CategoryRow(),
            ),
            SizedBox(height: AppSizes.xl - 8),
            Padding(
              padding: EdgeInsets.only(left: AppSizes.paddingX),
              child: Text(
                "Jajanan di Sekitar",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F374A),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSizes.paddingX),
              child: Container(
                width: double.infinity,
                height: 250.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: AppSizes.radiusSm,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      child: provider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : provider.currentPosition == null
                          ? Center(
                              child: IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () => provider.refreshLocation(),
                              ),
                            )
                          : FlutterMap(
                              options: MapOptions(
                                initialCenter: provider.currentPosition!,
                                initialZoom: 12.0,
                                interactionOptions: const InteractionOptions(
                                  flags: InteractiveFlag.none,
                                ),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'id.ac.binus.laperbang',
                                ),
                                CircleLayer(
                                  circles: [
                                    CircleMarker(
                                      point: provider.currentPosition!,
                                      color: Colors.blue.withOpacity(0.12),
                                      borderColor: Colors.blue.withOpacity(0.5),
                                      borderStrokeWidth: 1.5,
                                      useRadiusInMeter: true,
                                      radius: 5000.0,
                                    ),
                                  ],
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: provider.currentPosition!,
                                      width: 24,
                                      height: 24,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 3.0,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.2,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    for (var objek in objekDalamRadius)
                                      Marker(
                                        point: objek['lokasi'],
                                        width: 40,
                                        height: 40,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: 34,
                                              height: 34,
                                              decoration: BoxDecoration(
                                                color: _getMarkerColor(
                                                  objek['kategori'],
                                                ),
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.15),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              _getMarkerIcon(objek['kategori']),
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18.r,
                        child: IconButton(
                          icon: Icon(
                            Icons.my_location,
                            color: primaryBlue,
                            size: 18.sp,
                          ),
                          onPressed: () => provider.refreshLocation(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
