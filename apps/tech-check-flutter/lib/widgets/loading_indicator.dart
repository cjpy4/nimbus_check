import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CloudLoadingIndicator extends StatelessWidget {
  const CloudLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 500,
          height: 500,
          child: Lottie.asset('assets/CloudLoadingIndicator.json'),
        ),
      ],
    );
  }
}
