import 'package:flutter/material.dart';

class AppDecorations {
  static BoxDecoration cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
