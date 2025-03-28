import 'package:flutter/material.dart';
import 'models/result.dart';
import 'networking.dart';

class ResponseTable extends StatefulWidget {
  final String imei;

  const ResponseTable({super.key, required this.imei});

  @override
  State<ResponseTable> createState() => _ResponseTableState();
}

class _ResponseTableState extends State<ResponseTable> {
  List<Result> _results = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  Future<void> _fetchResults() async {
    setState(() => _isLoading = true);
    try {
      final results = await getResults(
        'beta',
        'V29-1J2-0JX-CDL-DFT-TUZ-SM6-BHJ',
        '61',
        widget.imei,
      );
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : Expanded(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      dataTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 16,
                      ),
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Name',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
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
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows:
                          _results
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
              ],
            ),
          ),
        );
  }
}
