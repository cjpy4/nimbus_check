import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/imei_form_widget.dart';
import 'widgets/results_list_widget.dart';
import 'widgets/search_history_widget.dart';
import 'providers/check_provider.dart';
import 'repositories/search_repository.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech Check'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search history chips
          SearchHistoryWidget(
            onSelect: (imei) {
              // TODO: Implement selecting from history
              // This could scroll to the specific result or highlight it
            },
          ),
          
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
    );
  }
}