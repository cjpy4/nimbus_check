import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/result.dart';
// import '../providers/check_provider.dart';


class ResultTableWidget extends StatelessWidget {
  final String imei;
  final Map<String, dynamic> results;

  const ResultTableWidget({
    super.key,
    required this.imei,
    required this.results,
  });
  
  @override
  Widget build(BuildContext context) {
    double maxWidth;
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
                  _buildHeader(context),
                  _buildContent(context, results, maxWidth),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
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
          Text(
            'IMEI: $imei',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          // IconButton(
          //   icon: const Icon(Icons.refresh),
          //   onPressed: () {
          //     // Manually refresh this specific result
          //   },
          //   color: Theme.of(context).colorScheme.onPrimaryContainer,
          //   tooltip: 'Refresh results',
          // ),
          // TODO: Implement live account balance
          Text('Remaining Checks: 27'),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> results, double maxWidth) {
    // Filter out null or empty values
    final filteredResults = Map.fromEntries(
      results.entries.where((entry) => 
        entry.value != null && 
        entry.value.toString().trim().isNotEmpty
      )
    );

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
                        'Name',
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
                        'Value',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
                rows: filteredResults.entries
                    .map(
                      (entry) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(entry.key, style: const TextStyle(fontSize: 13))),
                          DataCell(Text(entry.value.toString(), style: const TextStyle(fontSize: 13))),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          );
  }
}