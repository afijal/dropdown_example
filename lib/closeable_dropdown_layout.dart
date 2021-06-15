import 'package:flutter/widgets.dart';

class CloseableDropdownLayout extends SingleChildLayoutDelegate {
  CloseableDropdownLayout({
    required this.textDirection,
    this.xOffset = 0,
    this.yOffset = 0,
    this.minWidth = 0,
    this.minHeight = 0,
    this.maxHeight = 0,
    this.maxWidth = 0,
  });

  final TextDirection textDirection;
  final double yOffset;
  final double xOffset;
  final double minHeight;
  final double maxHeight;
  final double minWidth;
  final double maxWidth;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(xOffset, yOffset);
  }

  @override
  bool shouldRelayout(CloseableDropdownLayout oldDelegate) {
    return textDirection != oldDelegate.textDirection ||
        xOffset != oldDelegate.xOffset ||
        yOffset != oldDelegate.yOffset ||
        minHeight != oldDelegate.minHeight ||
        maxHeight != oldDelegate.maxHeight ||
        minWidth != oldDelegate.minWidth ||
        maxWidth != oldDelegate.maxWidth;
  }
}
