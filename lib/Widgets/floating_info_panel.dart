import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import '../app_constants.dart';

class FloatingInfoPanel extends StatelessWidget {
  final LatLng currentPosition;
  final LatLng targetPosition;

  const FloatingInfoPanel({
    super.key,
    required this.currentPosition,
    required this.targetPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on),
              SizedBox(width: AppSizes.sm),
              Text(
                '${currentPosition.latitude.toStringAsFixed(5)}, ${currentPosition.longitude.toStringAsFixed(5)}',
                style: TextStyle(fontSize: 12.sp, color: Colors.blueAccent),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              const Icon(Icons.pin_drop_outlined),
              SizedBox(width: AppSizes.sm),
              Text(
                '${targetPosition.latitude.toStringAsFixed(5)}, ${targetPosition.longitude.toStringAsFixed(5)}',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}