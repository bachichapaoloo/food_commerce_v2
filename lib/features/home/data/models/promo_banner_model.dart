import 'dart:ui';

class PromoBanner {
  final String imageUrl;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const PromoBanner({required this.imageUrl, required this.title, required this.subtitle, this.onTap});
}
