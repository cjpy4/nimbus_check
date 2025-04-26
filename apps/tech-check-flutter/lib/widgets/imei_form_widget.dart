import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer';
import '../models/serviceTypes.dart';

class IMEIFormWidget extends StatefulWidget {
  final Function(String, ServiceType) onSubmit;

  const IMEIFormWidget({super.key, required this.onSubmit});

  @override
  State<IMEIFormWidget> createState() => _IMEIFormWidgetState();
}

class _IMEIFormWidgetState extends State<IMEIFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _isLoading = false;
  ServiceType _selectedService = ServiceType.appleWatch;
  bool _dropdownOpen = false;
  bool _dropdownHover = false;

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
          widget.onSubmit(_controller.text, _selectedService);
          _controller.clear();
          setState(() => _isLoading = false);
        }
      });
    }
  }

  // Helper to get the display widget for the selected service
  Widget _serviceIcon({bool withText = false}) {
    final icon = Icon(_selectedService.icon, size: 18);
    if (withText) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 4),
          Text(_selectedService.displayName, style: const TextStyle(fontSize: 13)),
        ],
      );
    } else {
      return icon;
    }
  }

  Future<void> _showServiceMenu(BuildContext context) async {
    setState(() => _dropdownOpen = true);
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);
    final selected = await showMenu<ServiceType>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + button.size.height,
        position.dx + button.size.width,
        position.dy,
      ),
      items: ServiceType.values.map((service) {
        return PopupMenuItem<ServiceType>(
          value: service,
          child: Row(
            children: [
              Icon(service.icon, size: 18),
              const SizedBox(width: 4),
              Text(service.displayName, style: const TextStyle(fontSize: 13)),
            ],
          ),
        );
      }).toList(),
    );
    if (selected != null && selected != _selectedService) {
      setState(() {
        _selectedService = selected;
      });
    }
    setState(() => _dropdownOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        if (screenWidth < 600) {
          maxWidth = double.infinity;
        } else if (screenWidth < 1200) {
          maxWidth = screenWidth * 1 / 2;
        } else {
          maxWidth = screenWidth * 2 / 5;
        }
        return Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24.0,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 24.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _controller,
                              decoration: InputDecoration(
                                labelText: 'Enter IMEI',
                                hintText: 'e.g., 123456789012345',
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    bottomLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    bottomLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    bottomLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                  ),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    bottomLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                  ),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    bottomLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                  ),
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                                  child: Builder(
                                    builder: (dropdownContext) => MouseRegion(
                                      onEnter: (_) => setState(() => _dropdownHover = true),
                                      onExit: (_) => setState(() => _dropdownHover = false),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        curve: Curves.easeInOut,
                                        width: (_dropdownOpen || _dropdownHover) ? 140 : 36,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(4),
                                          onTap: () => _showServiceMenu(dropdownContext),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              _serviceIcon(withText: _dropdownOpen || _dropdownHover),
                                              const Icon(Icons.arrow_drop_down, size: 18),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () => _controller.clear(),
                                  tooltip: 'Clear',
                                ),
                              ),
                              validator: _validateIMEI,
                              keyboardType: TextInputType.text,
                              inputFormatters: [
                                // FilteringTextInputFormatter.digitsOnly,
                                // LengthLimitingTextInputFormatter(15),
                              ],
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submitForm(),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(4.0),
                                  bottomRight: Radius.circular(4.0),
                                ),
                              ),
                              minimumSize: const Size(0, 56),
                            ),
                            child:
                                _isLoading
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text(
                                      'SEARCH',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ],
                      ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
