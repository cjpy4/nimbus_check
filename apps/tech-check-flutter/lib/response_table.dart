// import 'package:flutter/material.dart';
// import 'models/result.dart';
// import 'networking.dart';

// class ResponseTable extends StatefulWidget {
//   final String imei;

//   const ResponseTable({super.key, required this.imei});

//   @override
//   State<ResponseTable> createState() => _ResponseTableState();
// }

// class _ResponseTableState extends State<ResponseTable> {
//   List<Result> _results = [];
//   bool _isLoading = false;

//   @override
//   void initState() {
//     print('Initializing ResponseTable with IMEI: ${widget.imei}');
//     super.initState();
//     // Call _fetchResults after the widget is built
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchResults();
//     });
//   }

//   Future<void> _fetchResults() async {
//     print('_fetchResults called');
//     setState(() => _isLoading = true);
//     try {
//       print('Fetching results for IMEI: ${widget.imei}');
//       final results = await getResults(
//         'beta',
//         'V29-1J2-0JX-CDL-DFT-TUZ-SM6-BHJ',
//         'demo',
//         widget.imei,
//       );
//       print('Got results: $results');
//       setState(() {
//         _results = results;
//         _isLoading = false;
//       });
//       print('State updated with ${_results.length} results');
//     } catch (e) {
//       print('Error in _fetchResults: $e');
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? const Center(child: CircularProgressIndicator())
//         : Container(
//           padding: const EdgeInsets.all(30.0),
//           child: SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             child: DataTable(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primaryContainer,
//                 borderRadius: const BorderRadius.all(Radius.circular(10)),
//               ),
//               dataTextStyle: TextStyle(
//                 color: Theme.of(context).colorScheme.onPrimaryContainer,
//                 fontSize: 16,
//               ),
//               columns: const <DataColumn>[
//                 DataColumn(
//                   label: Expanded(
//                     child: Text(
//                       'Name',
//                       style: TextStyle(
//                         fontStyle: FontStyle.italic,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Expanded(
//                     child: Text(
//                       'Value',
//                       style: TextStyle(
//                         fontStyle: FontStyle.italic,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//               rows:
//                   _results
//                       .map(
//                         (result) => DataRow(
//                           cells: <DataCell>[
//                             DataCell(Text(result.key)),
//                             DataCell(Text(result.value)),
//                           ],
//                         ),
//                       )
//                       .toList(),
//             ),
//           ),
//         );
//   }
// }