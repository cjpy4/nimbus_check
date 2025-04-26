import 'package:flutter/material.dart';

enum ServiceType {
  appleWatch(displayName: 'Apple Watch', route: '/applewatch', icon: Icons.watch),
  airPods(displayName: 'Air Pods', route: '/airpods', icon: Icons.headphones),
  iPhone(displayName: 'iPhone', route: '/iphone', icon: Icons.smartphone),
  iPad(displayName:'iPad', route: '/ipad', icon: Icons.tablet),
  iMac(displayName:'iMac', route: '/imac', icon: Icons.desktop_mac),
  macBook(displayName:'MacBook', route: '/macbook', icon: Icons.laptop_mac);

  // serviceKeys: [61, 72]

  final String displayName;
  final String route;
  final IconData icon;

  // --- Constructor ---

  // A 'const' constructor to initialize the fields for each constant above
  const ServiceType({required this.displayName, required this.route, required this.icon});
}
