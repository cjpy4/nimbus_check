import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyButton extends StatelessWidget {
  const CopyButton({super.key, required this.searchNum});
  final String searchNum;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.copy, size: 20),
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      padding: EdgeInsets.zero,
      tooltip: 'Copy Search number',
      onPressed: () async {
        //final imei = search['IMEI'] ?? search['imei'];
        await Clipboard.setData(ClipboardData(text: searchNum));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Search number copied to clipboard'),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }
}
