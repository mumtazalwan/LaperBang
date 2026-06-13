import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../app_constants.dart';

class PromoSlider extends StatefulWidget {
  const PromoSlider({Key? key}) : super(key: key);

  @override
  State<PromoSlider> createState() => _PromoSliderState();
}

class _PromoSliderState extends State<PromoSlider> {
  int _currentIndex = 0;

  final List<String> promoImages = [
    'assets/1.jpg',
    'assets/2.jpg',
    'assets/3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: promoImages.map((imagePath) {
            return Builder(
              builder: (BuildContext context) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: Image.asset(imagePath, fit: BoxFit.cover),
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: 150.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 8),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.linear,
            viewportFraction: 0.85,
            enableInfiniteScroll: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        SizedBox(height: AppSizes.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: promoImages.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentIndex == entry.key ? AppSizes.xl : AppSizes.sm,
              height: AppSizes.sm,
              margin: EdgeInsets.symmetric(horizontal: AppSizes.sm / 2),
              decoration: BoxDecoration(
                color: _currentIndex == entry.key ? Colors.blue : Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm + 2),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}