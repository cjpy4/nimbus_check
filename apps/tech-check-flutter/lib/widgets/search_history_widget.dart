import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/repositories/search_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchHistoryWidget extends ConsumerWidget {
  const SearchHistoryWidget({super.key});
  
  String formatCreatedAt(dynamic createdAt) {
    if (createdAt == null) return 'No timestamp';
  
    if (createdAt is DateTime) {
      return '${createdAt.toLocal()}';
      // or use intl package for pretty formatting.
      // DateFormat.yMMMd().add_jm().format(createdAt)
    }
    // If you use Firestore Timestamp:
    if (createdAt is Timestamp) {
      // From cloud_firestore, to DateTime
      return '${createdAt.toDate().toLocal()}';
    }
    // If it's a String (maybe already serialized)
    if (createdAt is String) {
      // Try to parse it
      try {
        final parsed = DateTime.parse(createdAt);
        return '${parsed.toLocal()}';
      } catch (_) {
        return createdAt;
      }
    }
    // Anything else
    return createdAt.toString();
  }

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
                IconButton(
                  onPressed: () {
                    // ref.read(searchHistoryProvider.notifier).clearHistory();
                  },
                  icon: Icon(Icons.close),
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
                      return ListTile(
                        // Use ListTile for better structure and tap target
                        title: Text(imei['IMEI']),
                        trailing: Text(
                          formatCreatedAt(imei['createdAt']),
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
