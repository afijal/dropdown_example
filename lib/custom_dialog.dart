import 'package:flutter/material.dart';

import 'constants.dart';
import 'decoration_util.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    required this.items,
    required this.xOriginOffset,
    required this.yOriginOffset,
    required this.originWidth,
  }) : super(key: key);

  static Future<String?> showItems<T>(
    BuildContext context,
    GlobalKey originKey,
    Iterable<String> items,
  ) {
    final barrierColor = Colors.white.withOpacity(0.8);
    final renderBox = originKey.currentContext!.findRenderObject() as RenderBox;
    final xOffset = renderBox.localToGlobal(Offset.zero).dx;
    final yOffset = renderBox.localToGlobal(Offset.zero).dy;
    final width = renderBox.size.width;

    return showDialog(
      context: context,
      useRootNavigator: false,
      barrierColor: barrierColor,
      useSafeArea: false,
      builder: (context) => CustomDialog(
        items: items,
        xOriginOffset: xOffset,
        yOriginOffset: yOffset,
        originWidth: width,
      ),
    );
  }

  final double xOriginOffset;
  final double yOriginOffset;
  final double originWidth;
  final Iterable<String> items;

  Widget _postionChild(double xOffset, double yOffset, double dropdownHeight, double maxWidth, bool isOnRightHalf,
          {required Widget child}) =>
      isOnRightHalf
          ? Positioned(
              child: child,
              top: yOffset,
              height: dropdownHeight,
              right: modalHorizontalPadding,
            )
          : Positioned(
              child: child,
              top: yOffset,
              height: dropdownHeight,
              left: xOffset,
            );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final expandedHeight = closeHeaderHeight + items.length * itemHeight + borderWidth;

      final topConstraint = AppBar().preferredSize.height + MediaQuery.of(context).padding.top + modalVerticalPaddinng;
      final bootomConstraint = MediaQuery.of(context).padding.bottom + modalVerticalPaddinng;

      bool isOnRightHalf = xOriginOffset > MediaQuery.of(context).size.width / 2;

      final maxWidth = isOnRightHalf
          ? constraints.maxWidth - 2 * modalHorizontalPadding
          : constraints.maxWidth - xOriginOffset - modalHorizontalPadding;
      final availableVerticalSpace = constraints.maxHeight - yOriginOffset - collapsedHeight - modalVerticalPaddinng;

      final showAtTop = expandedHeight > availableVerticalSpace && yOriginOffset > constraints.maxHeight / 2;

      var calculatedYOffset = showAtTop
          ? yOriginOffset - expandedHeight - modalVerticalPaddinng
          : yOriginOffset + collapsedHeight + modalVerticalPaddinng;
      final wouldOverflow = calculatedYOffset + expandedHeight > constraints.maxHeight - bootomConstraint ||
          calculatedYOffset < topConstraint;
      final maxExpandedHeight = wouldOverflow
          ? (showAtTop
              ? yOriginOffset - topConstraint - modalVerticalPaddinng
              : availableVerticalSpace - bootomConstraint)
          : expandedHeight;
      if (wouldOverflow && showAtTop) calculatedYOffset = topConstraint;

      return Stack(
        children: [
          _postionChild(
            xOriginOffset,
            calculatedYOffset,
            maxExpandedHeight,
            maxWidth,
            isOnRightHalf,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: _buildContent(
                context,
                maxExpandedHeight,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildContent(BuildContext context, double maxExpandedHeight) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: DecorationUtil.getDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildExpandedHeader(context),
            _buildExpandedItems(context, maxExpandedHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedHeader(BuildContext context) {
    return SizedBox(
      height: closeHeaderHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(width: 16),
          Text('Close'),
          SizedBox(width: 4),
          IconButton(
            splashRadius: 24,
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              size: 24,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(width: 4),
        ],
      ),
    );
  }

  // we need maxheight so we won't render overflow out of the screen, we will have limited space available
  Widget _buildExpandedItems(BuildContext context, double maxExpandedHeight) {
    final maxHeight = maxExpandedHeight - closeHeaderHeight - borderWidth;
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: items
                  .map(
                    (e) => Material(
                      color: Colors.transparent,
                      child: InkWell(
                        //we want a feedback that the item was clicked
                        onTap: () => Navigator.of(context).pop(e),
                        child: SizedBox(
                            height: itemHeight,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                              child: Text(
                                e,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                      ),
                    ),
                  )
                  .toList()),
        ));
  }
}
