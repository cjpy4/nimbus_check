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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech Check'),
        elevation: 0,
        actions: [
          // Button to open the end drawer
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Search History',
            onPressed: () {
              Scaffold.of(context).openEndDrawer(); // Open the end drawer
            },
          ),
        ],
      ),
      // End drawer for search history
      endDrawer: const SearchHistoryWidget(),
      body: Builder( // Use Builder to get context for Scaffold.of(context)
        builder: (context) => Column(
          children: [
            // Main content - scrollable list of results
            const Expanded(
              child: ResultsListWidget(),
            ),
            
            // IMEI form at the bottom
            IMEIFormWidget(
              onSubmit: (imei) {
                // Trigger the providers with the specific IMEI
                ref.read(checkProvider(imei));
              },
            ),
          ],
        ),
      ),
    );
  }
}
