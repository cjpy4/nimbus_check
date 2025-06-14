import 'package:flutter/material.dart';

class NavRail extends StatefulWidget {
  const NavRail({super.key});

  @override
  State<NavRail> createState() => _NavRailState();
}

class _NavRailState extends State<NavRail> {
  int _selectedIndex = 0;
  bool showLeading = true;
  bool showTrailing = true;
  double groupAlignment = -1.0;
  bool expanded = false;
  NavigationRailLabelType labelType = NavigationRailLabelType.none;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: NavigationRail(
              minExtendedWidth: 180.0,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerLow,
              extended: expanded,
              selectedIndex: _selectedIndex,
              groupAlignment: groupAlignment,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: labelType,
              leading:
                  showLeading
                      ? Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              expanded = !expanded;
                            });
                          },
                          icon:
                              expanded
                                  ? Icon(Icons.menu_open)
                                  : Icon(Icons.menu),
                        ),
                      )
                      : const SizedBox(),
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite),
                  label: Text('First'),
                ),
                NavigationRailDestination(
                  icon: Badge(child: Icon(Icons.bookmark_border)),
                  selectedIcon: Badge(child: Icon(Icons.book)),
                  label: Text('Second'),
                ),
                NavigationRailDestination(
                  icon: Badge(label: Text('4'), child: Icon(Icons.star_border)),
                  selectedIcon: Badge(
                    label: Text('4'),
                    child: Icon(Icons.star),
                  ),
                  label: Text('Third'),
                ),
              ],
              minWidth: null,
            ),
          ),
          if (showTrailing)
            Container(
              width: 80.0,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: IconButton(
                onPressed: () {
                  // Add your onPressed code here!
                },
                icon: const Icon(Icons.sunny),
              ),
            ),
        ],
      ),
    );
  }
}
