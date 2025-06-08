import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nimbus_check/widgets/result_table_widget.dart';
import 'package:nimbus_check/providers/search_providers.dart';
import 'package:nimbus_check/widgets/logo_widget.dart';


class ResultsPage extends ConsumerWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchHistory = ref.watch(searchHistoryProvider);

    return Center(
      child: searchHistory.when(
        data: (data) {
          if (data.isEmpty) {
            return Logo();
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              // final imei = data[index]['imei'] ?? 'Unknown IMEI';
              final record = data[index];
              return ResultTableWidget(results: record);
            },
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Text('Error: $error'),
      ),
    );
  }
}
