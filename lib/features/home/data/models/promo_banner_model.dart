import 'package:flutter/painting.dart';

class PromoBanner {
  final String id;
  final String imageUrl;
  final String title;
  final String? subtitle;
  final String? deepLink; // e.g., "category:burgers"
  VoidCallback? onTap;

  PromoBanner({required this.id, required this.imageUrl, required this.title, this.subtitle, this.deepLink, this.onTap});
}

// Dummy Data for now (Later fetching from Supabase 'promos' table)
final List<PromoBanner> dummyPromos = [
  PromoBanner(
    id: '1',
    imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    title: "50% Off Burgers",
  ),
  PromoBanner(
    id: '2',
    imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591',
    title: "Free Pizza Friday",
  ),
];
