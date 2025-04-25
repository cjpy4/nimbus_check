
enum ServiceType {
  appleWatch(displayName: 'Apple Watch', route: '/applewatch'),
  airPods(displayName: 'Air Pods', route: '/airpods'),
  iPhone(displayName: 'iPhone', route: '/iphone'),
  iPad(displayName:'iPad', route: '/ipad'),
  iMac(displayName:'iMac', route: '/imac'),
  macBook(displayName:'MacBook', route: '/macbook');

  // serviceKeys: [61, 72]

  final String displayName;
  final String route; 

  // --- Constructor ---

  // A 'const' constructor to initialize the fields for each constant above
  const ServiceType({required this.displayName, required this.route});
}
