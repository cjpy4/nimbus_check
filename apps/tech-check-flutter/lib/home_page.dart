import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/imei_form_widget.dart';
import 'widgets/results_list_widget.dart';
import 'widgets/search_history_widget.dart';
import 'providers/check_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: Theme.of(
        context,
      ).copyWith(drawerTheme: DrawerThemeData(scrimColor: Colors.transparent)),
      child: Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   actions: [
        //     // Button to open the end drawer
        //   ],
        // ),
        // End drawer for search history
        endDrawer: const SearchHistoryWidget(),
        body: Builder(
          builder:
              (context) => Stack(
                children: [
                  // Main content - scrollable list of results
                  const Positioned.fill(child: ResultsListWidget()),
                  Positioned(
                    width: 64,
                    right: 0,
                    bottom: 300,
                    child: IconButton(
                      icon: const Icon(Icons.history),
                      tooltip: 'Search History',
                      onPressed: () {
                        Scaffold.of(
                          context,
                        ).openEndDrawer(); // Open the end drawer
                      },
                    ),
                  ),
                  // Floating IMEI form at the bottom center
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 32,
                    child: Center(
                      child: IMEIFormWidget(
                        onSubmit: (imei, serviceType) {
                          ref.read(checkProvider(imei, serviceType));
                        },
                      ),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
