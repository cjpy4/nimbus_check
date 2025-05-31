import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/imei_form_widget.dart';
import '../widgets/search_history_widget.dart';
import '../providers/check_provider.dart';
import '../widgets/logo_widget.dart'; // Import the new Logo widget

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  bool _isDrawerOpen = false;

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content centered
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Logo(),
                  IMEIFormWidget(
                    onSubmit: (imei, serviceType) {
                      ref.read(checkProvider(imei, serviceType));
                      Navigator.pushNamed(context, '/results');
                    },
                  ),
                ],
              ),
            ),
          ),
          // Search history drawer overlay
          SearchHistoryWidget(isOpen: _isDrawerOpen, onToggle: _toggleDrawer),
        ],
      ),
    );
  }
}
