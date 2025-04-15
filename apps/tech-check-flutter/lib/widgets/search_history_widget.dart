import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/check_provider.dart';
import '/repositories/search_repository.dart';

class SearchHistoryWidget extends ConsumerWidget {
  const SearchHistoryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchHistory = ref.watch(searchHistoryProvider);

    return Drawer(
      // Wrap content in a Drawer
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Make children fill width
        children: [
          // Drawer Header
          Padding(
            padding: EdgeInsets.fromLTRB(
              16.0,
              MediaQuery.of(context).padding.top + 16.0,
              16.0,
              16.0,
            ), // Adjust top padding for status bar
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style:
                      Theme.of(
                        context,
                      ).textTheme.titleLarge, // Use theme text style
                ),
                TextButton(
                  onPressed: () {
                    // ref.read(searchHistoryProvider.notifier).clearHistory();
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Show message if history is empty
          if (!searchHistory.hasValue)
            const Expanded(child: Center(child: Text('No recent searches.')))
          else
            // Scrollable list of history items
            Expanded(
              // Make the list take remaining space
              child: searchHistory.when(
                data: (searches) {
                  if (searches.isEmpty) {
                    return const Center(child: Text('No checks yet.'));
                  }

                  return ListView.builder(
                    // Use ListView.builder for vertical list
                    itemCount: searches.length,
                    itemBuilder: (context, index) {
                      final imei = searches[index];
                      print(imei);
                      return ListTile(
                        // Use ListTile for better structure and tap target
                        title: Text('placholder'),
                        trailing: IconButton(
                          // Use IconButton for delete action
                          icon: const Icon(Icons.close, size: 18),
                          tooltip: 'Remove search',
                          onPressed: () {
                            // ref.read(searchHistoryProvider).removeSearch(imei);
                          },
                        ),
                        onTap: () {
                          // Trigger the check for the selected IMEI
                          //ref.read(checkProvider(imei));
                          Navigator.pop(
                            context,
                          ); // Close the drawer after selection
                        },
                      );
                    },
                  );
                },
                error:
                    (error, stackTrace) => Center(
                      child: Text('Error loading search history: $error'),
                    ),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
