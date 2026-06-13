import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../Helper/database.dart';

class JajanProvider extends ChangeNotifier {
  final String baseUrl = "https://laper-bang-backend.vercel.app/api/v1";

  int mainTabIndex = 0;
  bool mapAutoFocus = false;
  bool isLoading = true;
  bool isDbLoading = true;
  bool isPusherInitialized = false;

  LatLng? currentPosition;
  List<Map<String, dynamic>> objekSekitar = [];
  Map<String, dynamic>? selectedVendor;
  LatLng? targetPosition;

  List<LatLng> rutePoints = [];
  Timer? trackingTimer;

  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> favoriteData = [];

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  Future<void> initData() async {
    isDbLoading = true;
    isLoading = true;
    notifyListeners();
    await _getCurrentLocation();
    await loadFavorites();
    isDbLoading = false;
    isLoading = false;
    notifyListeners();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition = LatLng(position.latitude, position.longitude);
    } catch (e) {
      currentPosition = const LatLng(-6.43202, 106.80898);
    }

    await fetchNearbyVendors(
      currentPosition!.latitude,
      currentPosition!.longitude,
    );
  }

  Future<void> refreshLocation() async {
    isLoading = true;
    notifyListeners();
    await _getCurrentLocation();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchNearbyVendors(double lat, double lng) async {
    final url = '$baseUrl/vendors/nearby?lat=$lat&lng=$lng&radius=100000';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List rawList = data['data'] ?? [];

        objekSekitar = rawList.map((item) {
          return {
            'id': item['vendor_id'],
            'nama': item['name'],
            'kategori':
                item['user']?['vendor_additional_info']?['type'] == 'food'
                ? 'Makanan Berat'
                : 'Cemilan',
            'lokasi': LatLng(
              double.parse(item['lat'].toString()),
              double.parse(item['lng'].toString()),
            ),
            'jarak_meter': item['distance'],
            'rating': item['user']?['vendor_additional_info']?['rating'],
            'starting_price':
                item['user']?['vendor_additional_info']?['starting_price'],
            'description': item['user']?['description'],
          };
        }).toList();

        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void changeTab(int index) {
    mainTabIndex = index;
    notifyListeners();
  }

  void goToMapAndSearch() {
    mapAutoFocus = true;
    mainTabIndex = 1;
    notifyListeners();
  }

  void clearSearchFocus() {
    mapAutoFocus = false;
    notifyListeners();
  }

  void selectVendor(Map<String, dynamic> vendor) {
    selectedVendor = vendor;
    targetPosition = vendor['lokasi'];
    notifyListeners();
  }

  Future<void> fetchRoute(LatLng start, LatLng end) async {
    final url =
        'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List coordinates = data['routes'][0]['geometry']['coordinates'];
        rutePoints = coordinates.map((c) => LatLng(c[1], c[0])).toList();
      } else {
        rutePoints = [start, end];
      }
    } catch (e) {
      rutePoints = [start, end];
    }
    notifyListeners();
  }

  void startNavigation(
    Map<String, dynamic> v,
    VoidCallback onArrival,
    Function(String) onError,
    Function(LatLng) onMapMove,
  ) async {
    selectVendor(v);
    mapAutoFocus = true;
    mainTabIndex = 1;

    if (currentPosition != null && targetPosition != null) {
      await fetchRoute(currentPosition!, targetPosition!);
    }

    notifyListeners();
  }

  void stopFollowingVendor() async {
    if (selectedVendor != null) {
      String vendorId =
          selectedVendor!['id']?.toString() ??
          selectedVendor!['vendor_id']?.toString() ??
          '';
      if (vendorId.isNotEmpty) {
        await unsubscribePusher(vendorId);
      }
    }
    rutePoints.clear();
    trackingTimer?.cancel();
    notifyListeners();
  }

  void clearSelection() async {
    if (selectedVendor != null) {
      String vendorId =
          selectedVendor!['id']?.toString() ??
          selectedVendor!['vendor_id']?.toString() ??
          '';
      if (vendorId.isNotEmpty) {
        await unsubscribePusher(vendorId);
      }
    }
    selectedVendor = null;
    targetPosition = null;
    rutePoints.clear();
    trackingTimer?.cancel();
    notifyListeners();
  }

  void stopNavigation() {
    clearSelection();
  }

  Future<void> loadFavorites() async {
    isDbLoading = true;
    notifyListeners();
    favoriteData = await dbHelper.getFavorites();
    isDbLoading = false;
    notifyListeners();
  }

  bool isFavorite(String id) => favoriteData.any((e) => e['vendor_id'] == id);

  Future<void> toggleFavorite(Map<String, dynamic> v) async {
    String id = v['id']?.toString() ?? v['vendor_id']?.toString() ?? '';
    if (isFavorite(id)) {
      await dbHelper.deleteFavorite(id);
    } else {
      await dbHelper.insertFavorite({
        'vendor_id': id,
        'nama': v['nama'],
        'kategori': v['kategori'],
        'lat': v['lokasi'].latitude,
        'lng': v['lokasi'].longitude,
      });
    }
    await loadFavorites();
  }

  Future<bool> followVendorApi(String vendorId) async {
    final url = '$baseUrl/vendors/$vendorId/follow';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await subscribeToVendorPusher(vendorId);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> unfollowVendorApi(String vendorId) async {
    final url = '$baseUrl/vendors/$vendorId/follow';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint("➔ Berhasil Unfollow di Backend");
        return true;
      } else {
        debugPrint(
          "➔ Gagal Unfollow API: ${response.statusCode} - ${response.body}",
        );
        return false;
      }
    } catch (e) {
      debugPrint("➔ Error Unfollow: $e");
      return false;
    }
  }

  Future<void> subscribeToVendorPusher(String vendorId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (!isPusherInitialized) {
        await pusher.init(
          apiKey: "b7bc738b64432490b853",
          cluster: "ap1",
          onAuthorizer:
              (String channelName, String socketId, dynamic options) async {
                final authUrl = '$baseUrl/pusher/auth';

                try {
                  final response = await http.post(
                    Uri.parse(authUrl),
                    headers: {
                      'Content-Type': 'application/json',
                      'Accept': 'application/json',
                      if (token != null) 'Authorization': 'Bearer $token',
                    },
                    body: jsonEncode({
                      'socket_id': socketId,
                      'channel_name': channelName,
                    }),
                  );

                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    return jsonDecode(response.body);
                  } else {
                    throw Exception("Backend Auth Failed");
                  }
                } catch (e) {
                  throw Exception(e.toString());
                }
              },
          onConnectionStateChange: (currentState, previousState) {},
          onError: (message, code, error) {},
          onSubscriptionSucceeded: (channelName, data) {},
          onEvent: (event) {},
        );
        isPusherInitialized = true;
      }

      await pusher.subscribe(channelName: "private-vendor-$vendorId");
      await pusher.connect();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> unsubscribePusher(String vendorId) async {
    try {
      await pusher.unsubscribe(channelName: "private-vendor-$vendorId");
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
