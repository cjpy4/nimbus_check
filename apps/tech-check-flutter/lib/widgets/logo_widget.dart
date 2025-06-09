import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    final headlineLarge = Theme.of(context).textTheme.headlineLarge;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min, // To make the Row take minimum space
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: Lottie.asset(
                'assets/lightningLoad.json',
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text('Nimbus \r Check', style: headlineLarge),
            //Text('Check', style: headlineLarge),
          ],
        ),
      ],
    );
  }
}
