import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/result.dart';
// import '../providers/check_provider.dart';

class ResultTableWidget extends StatelessWidget {
  final Map<String, dynamic> results;
  
  // Safely get a value from a Map with a fallback
  String? safeGet(Map<String, dynamic> map, String key) {
    return map[key]?.toString();
  }

  const ResultTableWidget({super.key, required this.results});

  String formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'No timestamp';

    DateTime dateTime;

    if (timestamp is DateTime) {
      dateTime = timestamp.toLocal();
    } else if (timestamp is Timestamp) {
      dateTime = timestamp.toDate().toLocal();
    } else if (timestamp is String) {
      try {
        dateTime = DateTime.parse(timestamp).toLocal();
      } catch (_) {
        return timestamp;
      }
    } else {
      try {
        return timestamp.toString();
      } catch (_) {
        return 'Invalid timestamp';
      }
    }

    return DateFormat('MM/dd/yyyy, h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth;
    final data = results['result'] ?? results;

    // Display Fields
    final String searchNumber = (results['imei'] ?? results['IMEI'])?.toString() ?? 'Unknown';
    final orderNumber = results['id'];
    final timestamp = results['createdAt'];
    final accountBalance = results['balance'];
    final String deviceName = (data['Model Number'] ?? data['Model Name'] ?? data['Model Description'] ?? data['Model'] )?.toString()?? 'Unknown';

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        if (screenWidth < 600) {
          maxWidth = screenWidth * 0.95;
        } else if (screenWidth < 1200) {
          maxWidth = screenWidth * 0.6;
        } else {
          maxWidth = 900; // Fixed max width for larger screens
        }
        return Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            width: maxWidth,
            child: Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 4.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(
                    context,
                    deviceName,
                    orderNumber,
                    accountBalance,
                    timestamp,
                  ),
                  _buildContent(context, data, searchNumber, maxWidth),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    String deviceName,
    dynamic orderNumber,
    dynamic accountBalance,
    dynamic timestamp,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4.0),
          topRight: Radius.circular(4.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deviceName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (orderNumber != null)
                Row(
                  children: [
                    Text(
                      'Order #: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(orderNumber),
                  ],
                ),
              if (timestamp != null)
                Row(
                  children: [
                    Text(
                      'Created At: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(formatTimestamp(timestamp)),
                  ],
                ),
              Row(
                spacing: 4.0,
                children: [
                  Text(
                    'Account Balance:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('\$${accountBalance?.toString() ?? 'Check Account Page'}'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Map<String, dynamic> results,
    String searchNumber,
    double maxWidth,
  ) {
    // Ensure searchNumber is never null for display
    searchNumber = searchNumber.isNotEmpty ? searchNumber : 'Unknown';
    //var result = jsonResponse['result'] as Map<String, dynamic>;
    const finalResKeys = {
      'Model Name',
      'Serial Number',
      'IMEI',
      'iCloud Lock',
      'MDM Lock',
      'Sim-Lock Status',
      'Locked Carrier',
      'Blacklist Status',
    };

    final filteredResults = <String, dynamic>{};
    for (var key in finalResKeys) {
      if (results.containsKey(key) && results[key] != null) {
        filteredResults[key] = results[key];
      }
    }

    // Filter out null or empty values
    // final filteredResults = Map.fromEntries(
    //   results.entries.where(
    //     (entry) =>
    //         entry.value != null && entry.value.toString().trim().isNotEmpty,
    //   ),
    // );

    return filteredResults.isEmpty
        ? const Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(child: Text('No results found')),
        )
        : Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            child: DataTable(
              columnSpacing: 24,
              dataRowMaxHeight: double.infinity,
              dataRowMinHeight: 32,
              horizontalMargin: 16,
              border: TableBorder.all(color: Colors.transparent),
              columns: <DataColumn>[
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Search Number: ${searchNumber}',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      '',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
              rows:
                  filteredResults.entries
                      .map(
                        (entry) => DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text(
                                entry.key,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            DataCell(
                              Text(
                                entry.value?.toString() ?? 'N/A',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
            ),
          ),
        );
  }
}
