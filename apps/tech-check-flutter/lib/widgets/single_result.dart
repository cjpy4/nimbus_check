import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nimbus_check/providers/search_providers.dart';
import 'package:nimbus_check/widgets/result_table_widget.dart';

class SingleResult extends ConsumerWidget {
  final String docId;
  const SingleResult({super.key, required this.docId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(currentSearchProvider(docId));
    return Center(child: result.when(
      data: (data) => ResultTableWidget(results: data),
      error: (error, stackTrace) => Text('Error stuffs: $error'),
      loading: () => CircularProgressIndicator(),
    ));
  }
}
