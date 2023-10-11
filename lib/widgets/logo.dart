import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.messenger_outline,
      size: 64.0,
      color: Colors.amber[200],
    );
  }
}

class Slogan extends StatelessWidget {
  const Slogan({super.key});

  @override
  Widget build(BuildContext context) {
    // final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Logo(),
        const SizedBox.square(dimension: 16.0),
        Text(
          "Let's Talk",
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 208, 204, 204)),
        ),
      ],
    );
  }
}
