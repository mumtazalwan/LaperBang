import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Services/jajan_provider.dart';
import '../Widgets/floating_info_panel.dart';
import '../Widgets/floating_search_bar.dart';
import '../Widgets/pedagang_popup.dart';

class MapJajan extends StatefulWidget {
  const MapJajan({Key? key}) : super(key: key);

  @override
  State<MapJajan> createState() => _MapJajanState();
}

class _MapJajanState extends State<MapJajan> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<JajanProvider>();
      if (provider.mapAutoFocus) {
        provider.clearSearchFocus();
      }
    });
  }

  void _showPopupDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          content: Text(message, style: TextStyle(fontSize: 14.sp)),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _konfirmasiStopNavigasi() {
    final provider = context.read<JajanProvider>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            "Hentikan Navigasi?",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Text(
            "Apakah Anda yakin ingin menghentikan perjalanan ke pedagang ini?",
            style: TextStyle(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Tidak",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                provider.stopNavigation();
              },
              child: const Text(
                "Ya, Hentikan",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  LatLngBounds _getBoundsFromRadius(LatLng center, double radiusInMeters) {
    const distance = Distance();
    final north = distance.offset(center, radiusInMeters, 0);
    final east = distance.offset(center, radiusInMeters, 90);
    final south = distance.offset(center, radiusInMeters, 180);
    final west = distance.offset(center, radiusInMeters, 270);
    return LatLngBounds.fromPoints([north, east, south, west]);
  }

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

    if (provider.isLoading || provider.currentPosition == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    const distanceCalc = Distance();
    final objekDalamRadius = provider.objekSekitar.where((objek) {
      double jarak = distanceCalc.distance(
        provider.currentPosition!,
        objek['lokasi'],
      );
      return jarak <= 10000.0;
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCameraFit: CameraFit.bounds(
                bounds: _getBoundsFromRadius(provider.currentPosition!, 1000.0),
                padding: EdgeInsets.all(40.w),
              ),
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
              onTap: (tapPosition, point) {
                if (provider.trackingTimer != null && provider.trackingTimer!.isActive) {
                  _konfirmasiStopNavigasi();
                } else {
                  provider.clearSelection();
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'id.ac.binus.laperbang', // ⭐️ Nama paket sudah diganti
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: provider.currentPosition!,
                    color: Colors.blue.withOpacity(0.15),
                    borderColor: Colors.blue.withOpacity(0.6),
                    borderStrokeWidth: 2.0,
                    useRadiusInMeter: true,
                    radius: 5000.0,
                  ),
                ],
              ),
              if (provider.rutePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: provider.rutePoints,
                      color: Colors.blue,
                      strokeWidth: 5.0,
                      strokeCap: StrokeCap.round,
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
                        border: Border.all(color: Colors.white, width: 3.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
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
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          provider.selectVendor(objek);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _mapController.move(objek['lokasi'], 18.0);
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: _getMarkerColor(objek['kategori']),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              _getMarkerIcon(objek['kategori']),
                              color: Colors.white,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 50.h,
            left: 20.w,
            right: 20.w,
            child: provider.targetPosition == null
                ? CustomFloatingSearchBar(
              listJajanan: objekDalamRadius,
              autoFocus: provider.mapAutoFocus,
              onSelected: (jajananTerpilih) {
                provider.selectVendor(jajananTerpilih);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _mapController.move(jajananTerpilih['lokasi'], 18.0);
                });
              },
            )
                : FloatingInfoPanel(
              currentPosition: provider.currentPosition!,
              targetPosition: provider.targetPosition!,
            ),
          ),
          if (provider.selectedVendor != null)
            Positioned(
              bottom: 30.h,
              left: 20.w,
              right: 20.w,
              child: PedagangPopUpCard(
                pedagangData: provider.selectedVendor!,
                onCallPressed: () {},
                onFollowPressed: () {
                  final String namaPedagang = provider.selectedVendor!['nama'];

                  Future.delayed(const Duration(milliseconds: 100), () {
                    provider.startNavigation(
                      provider.selectedVendor!,
                          () => _showPopupDialog(
                        "Berhasil",
                        "Anda telah sampai di lokasi $namaPedagang!",
                      ),
                          (errorMsg) => _showPopupDialog("Maaf", errorMsg),
                          (newPos) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _mapController.move(
                            newPos,
                            _mapController.camera.zoom,
                          );
                        });
                      },
                    );
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}