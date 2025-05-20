// import 'package:flutter/material.dart';

// class IMEIForm extends StatefulWidget {
//   final Function(String) onSubmit;

//   const IMEIForm({super.key, required this.onSubmit});

//   @override
//   State<IMEIForm> createState() => _IMEIFormState();
// }

// class _IMEIFormState extends State<IMEIForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Form(
//         key: _formKey,
//         child: Row(
//           children: [
//             Expanded(
//               child: TextFormField(
//                 controller: _controller,
//                 decoration: const InputDecoration(
//                   labelText: 'Enter IMEI',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter an IMEI';
//                   }
//                   return null;
//                 },
//               ),
//             ),
//             const SizedBox(width: 16),
//             ElevatedButton(
//               onPressed: () {
//                 print('Button pressed with IMEI: ${_controller.text}');
//                 if (_formKey.currentState!.validate()) {
//                   widget.onSubmit(_controller.text);
//                   _controller.clear();
//                 }
//               },
//               child: const Text('Search'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
