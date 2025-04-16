import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/result.dart';
import '../providers/check_provider.dart';

class ResultTableWidget extends StatelessWidget {
  final String imei;
  final Map<String, dynamic> results; 
  
  const ResultTableWidget({
     super.key, 
     required this.imei, 
     required this.results
   });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          _buildContent(context, results),
        ],
      ),
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
          Text('Remaining Balance: \$100,000,000')
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Map<String, dynamic> results,
  ) {
    return results.isEmpty
        ? const Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(child: Text('No results found')),
        )
        : Container(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Name',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Value',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
        rows:
          results.entries
            .map(
              (entry) => DataRow(
                cells: <DataCell>[
                  DataCell(Text(entry.key)),
                  DataCell(Text(entry.value.toString())),
                ],
               ),
             )
              .toList(),
          ),
        ),
      );
  }
}
