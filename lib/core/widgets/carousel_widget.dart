import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:food_commerce_v2/features/home/data/models/promo_banner_model.dart';

class PromoCarousel extends StatelessWidget {
  final List<PromoBanner> banners;
  final double height;

  const PromoCarousel({super.key, required this.banners, this.height = 180});

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: height,
          child: CarouselSlider(
            options: CarouselOptions(height: height, enlargeCenterPage: true, autoPlay: true, viewportFraction: 0.8),
            items: banners.map((banner) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(image: NetworkImage(banner.imageUrl), fit: BoxFit.cover),
                ),
                child: _PromoOverlay(banner: banner),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _PromoOverlay extends StatelessWidget {
  final PromoBanner banner;

  const _PromoOverlay({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: banner.onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                banner.title,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (banner.subtitle != null) Text(banner.subtitle!, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
