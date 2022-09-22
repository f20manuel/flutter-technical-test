import 'package:flutter/material.dart';

/// Company colors
class CompanyColors {
  CompanyColors._();
  static const primary = Color(0xFFFFD233);
  static const black = Color(0xFF191919);
  static const grey = Color(0xFF8C8C8C);
  static MaterialColor materialPrimary = MaterialColor(
    primary.value,
    <int, Color>{
      50:  primary.withOpacity(0.05),
      100:  primary.withOpacity(0.1),
      200:  primary.withOpacity(0.2),
      300:  primary.withOpacity(0.3),
      400:  primary.withOpacity(0.4),
      500:  primary.withOpacity(0.5),
      600:  primary.withOpacity(0.6),
      700:  primary.withOpacity(0.7),
      800:  primary.withOpacity(0.8),
      900:  primary.withOpacity(0.9),
    },
  );
}