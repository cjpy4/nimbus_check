import 'package:flutter/material.dart';
import 'form.dart';
import 'response_table.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState(); 
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _tables = [];

  void _addNewSearch(String imei) {
    setState(() {
      _tables.insert(0, ResponseTable(imei: imei, key: UniqueKey()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: ListView(children: _tables)),
        IMEIForm(onSubmit: _addNewSearch),
      ],
    );
  }
}
