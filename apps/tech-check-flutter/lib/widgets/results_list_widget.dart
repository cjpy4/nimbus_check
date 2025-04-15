import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'result_table_widget.dart';
import '../repositories/search_repository.dart';

class ResultsListWidget extends ConsumerWidget {
  const ResultsListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchHistory = ref.watch(searchHistoryProvider);
    
    if (searchHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No searches yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter an IMEI to view device information',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: searchHistory.length,
      itemBuilder: (context, index) {
        final imei = searchHistory[index];
        return Dismissible(
          key: Key('result-$imei'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16.0),
            color: Colors.red,
            child: const Icon(Icons.delete_outline, color: Colors.white),
          ),
          onDismissed: (_) {
            //ref.read(searchHistoryProvider).removeSearch(imei);
          },
          child: ResultTableWidget(imei: imei),
        );
      },
    );
  }
}