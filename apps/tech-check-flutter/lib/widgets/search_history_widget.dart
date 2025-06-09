import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nimbus_check/providers/search_providers.dart';
import 'package:nimbus_check/models/service_types.dart';
import 'package:nimbus_check/widgets/copy_button.dart';

class SearchHistoryWidget extends ConsumerWidget {
  final bool isOpen;
  final VoidCallback onToggle;
  
  const SearchHistoryWidget({
    super.key,
    required this.isOpen,
    required this.onToggle,
  });
  
  String formatCreatedAt(dynamic createdAt) {
    if (createdAt == null) return 'No timestamp';
    
    DateTime dateTime;
    
    if (createdAt is DateTime) {
      dateTime = createdAt.toLocal();
    } else if (createdAt is Timestamp) {
      dateTime = createdAt.toDate().toLocal();
    } else if (createdAt is String) {
      try {
        dateTime = DateTime.parse(createdAt).toLocal();
      } catch (_) {
        return createdAt;
      }
    } else {
      return createdAt.toString();
    }
    
    // Format as MM/dd/yy, hh:mm a
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    String timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    
    if (date == today) {
      return 'Today, $timeStr';
    } else if (date == today.subtract(const Duration(days: 1))) {
      return 'Yesterday, $timeStr';
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year.toString().substring(2)}, $timeStr';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchHistory = ref.watch(searchHistoryProvider);

    // Increase drawer width from 280 to 350 pixels
    const double drawerWidth = 450;

    return Stack(
      children: [
        // Main drawer content
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          right: isOpen ? 0 : -drawerWidth, // Use the new width variable
          top: 0,
          bottom: 0,
          width: drawerWidth, // Use the new width variable
          child: Material(
            elevation: 16,
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
                      // IconButton to close the drawer
                      IconButton(
                        onPressed: () {
                          onToggle();
                        },
                        icon: const Icon(Icons.close),
                      ),
                      Text(
                        'Recent Searches',
                        style:
                            Theme.of(
                              context,
                            ).textTheme.titleLarge, // Use theme text style
                      ),
                      // Empty space to balance the row
                      const SizedBox(width: 48), // Fixed width for balance
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
                          return const Center(child: Text('No searches yet.'));
                        }

                        return ListView.builder(
                          // Use ListView.builder for vertical list
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
                          itemCount: searches.length,
                          itemBuilder: (context, index) {
                            final search = searches[index];
                            final String searchNumber = search['IMEI'] ?? search['imei'];

                            return Card(
                              elevation: 2.0,
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              child: InkWell(
                                onTap: () {
                                  
                                  // TODO: Add ServiceType to Card undneath the searchNumber

                                  // Determine service type - default to iPhone if not available
                                  ServiceType serviceType = ServiceType.iPhone;
                                  if (search['serviceType'] != null) {
                                    // Try to parse the service type string to enum
                                    try {
                                      final serviceTypeString = search['serviceType'].toString();
                                      serviceType = ServiceType.values.firstWhere(
                                        (type) => type.toString() == 'ServiceType.$serviceTypeString' || 
                                                  type.displayName == serviceTypeString,
                                        orElse: () => ServiceType.iPhone,
                                      );
                                    } catch (e) {
                                      // Fallback to default if parsing fails
                                      print('Error parsing service type: $e');
                                    }
                                  }
                                  
                                  // Trigger the check for the selected IMEI
                                 // ref.read(checkProvider(searchNumber, serviceType));
                                  
                                  // Close the drawer after selection
                                  onToggle();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      // Copy Button
                                      CopyButton(searchNum: searchNumber ),
                                      // Search number with bold text
                                      Expanded(
                                        child: Text(
                                          search['IMEI'] ?? search['imei'],
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      // Timestamp with fixed width
                                      Text(
                                        formatCreatedAt(search['createdAt']),
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
          ),
        ),
        // Pinned toggle button on the right edge
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          right: isOpen ? drawerWidth : 0, // Use the new width variable
          top: MediaQuery.sizeOf(context).height * 0.5 - 34,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(-4, 0), // Shadow only on the left side
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
              child: InkWell(
                onTap: onToggle,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
                child: Center(
                  child: Icon(
                    isOpen ? Icons.chevron_right : Icons.history,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
