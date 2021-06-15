import 'package:flutter/material.dart';

abstract class DecorationUtil {
  static BoxDecoration getDecoration() {
    return BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          width: 1,
          color: Colors.grey[600]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x45AAAAAA),
            blurRadius: 4,
            offset: Offset(0, 4),
          )
        ]);
  }
}
