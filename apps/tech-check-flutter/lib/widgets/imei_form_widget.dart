import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IMEIFormWidget extends StatefulWidget {
  final Function(String) onSubmit;

  const IMEIFormWidget({super.key, required this.onSubmit});

  @override
  State<IMEIFormWidget> createState() => _IMEIFormWidgetState();
}

class _IMEIFormWidgetState extends State<IMEIFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validateIMEI(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an IMEI';
    }

    // Check if IMEI is numeric and has correct length (usually 15 digits)
    // if (!RegExp(r'^\d+$').hasMatch(value)) {
    //   return 'IMEI should contain only digits';
    // }

    // if (value.length != 15) {
    //   return 'IMEI should be 15 digits long';
    // }

    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Submit the form - using a slight delay to show loading state
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          widget.onSubmit(_controller.text);
          _controller.clear();
          setState(() => _isLoading = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter IMEI',
                  hintText: 'e.g., 123456789012345',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.smartphone),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _controller.clear(),
                    tooltip: 'Clear',
                  ),
                ),
                validator: _validateIMEI,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submitForm(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text(
                          'SEARCH',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
