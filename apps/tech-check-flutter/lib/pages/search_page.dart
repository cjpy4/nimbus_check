import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nimbus_check/widgets/imei_form_widget.dart';
import 'package:nimbus_check/widgets/navigation_rail.dart';
import 'package:nimbus_check/widgets/search_history_widget.dart';
import 'package:nimbus_check/providers/check_provider.dart';
import 'package:nimbus_check/widgets/logo_widget.dart';
import 'package:nimbus_check/widgets/single_result.dart';
import 'package:nimbus_check/pages/results_page.dart';
import 'package:nimbus_check/models/view_options.dart';
import 'package:nimbus_check/widgets/loading_indicator.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  bool _isDrawerOpen = false;
  RenderedView currentView = RenderedView.home; // Default view is home
  late String docId;
  int _selectedIndex = 0;

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
          Positioned(left: 0, top: 0, bottom: 0, child: NavRail()),
          // Main content
          Positioned(
            left: 72, // NavigationRail default width
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  switch (currentView) {
                    RenderedView.home => Logo(),
                    RenderedView.loading => const CloudLoadingIndicator(),
                    RenderedView.singleResult => SingleResult(docId: docId),
                    RenderedView.resultList => ResultsPage(),
                  },
                  IMEIFormWidget(
                    onSubmit: (imei, serviceType) async {
                      setState(() {
                        currentView = RenderedView.loading;
                      });
                      try {
                        final result = await ref.read(
                          checkProvider(imei, serviceType).future,
                        );
                        setState(() {
                          docId = result;
                          currentView = RenderedView.singleResult;
                        });
                      } catch (error) {
                        // Handle error
                        print('Error: $error');
                      }
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
