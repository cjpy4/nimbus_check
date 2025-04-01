import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/result.dart';
import '../providers/result_providers.dart';

class ResultTableWidget extends ConsumerWidget {
  final String imei;

  const ResultTableWidget({super.key, required this.imei});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(resultsProvider(imei));

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, ref),
          _buildContent(context, ref, resultsAsync),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Manually refresh this specific result
              ref.invalidate(resultsProvider(imei));
            },
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            tooltip: 'Refresh results',
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Result>> resultsAsync,
  ) {
    return resultsAsync.when(
      loading:
          () => const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(child: CircularProgressIndicator()),
          ),
      error:
          (error, stack) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text('Error: ${error.toString()}'),
                TextButton(
                  child: const Text('Retry'),
                  onPressed: () {
                    // Retry the request
                    ref.invalidate(resultsProvider(imei));
                  },
                ),
              ],
            ),
          ),
      data:
          (results) =>
              results.isEmpty
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
                            results
                                .map(
                                  (result) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(result.key)),
                                      DataCell(Text(result.value)),
                                    ],
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ),
    );
  }
}
