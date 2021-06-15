import 'package:flutter/material.dart';

import '../constants.dart';
import '../decoration_util.dart';

class FinalLevelOne extends StatelessWidget {
  const FinalLevelOne({
    Key? key,
    required this.xOriginOffset,
    required this.yOriginOffset,
    required this.originWidth,
    required this.items,
  }) : super(key: key);

  static Future<String?> showItems<T>(
    BuildContext context,
    GlobalKey originKey,
    Iterable<String> items,
  ) {
    final renderBox = originKey.currentContext!.findRenderObject() as RenderBox;
    final barrierColor = Colors.white.withOpacity(0.7);
    final xOffset = renderBox.localToGlobal(Offset.zero).dx;
    final yOffset = renderBox.localToGlobal(Offset.zero).dy;
    final width = renderBox.size.width;

    return showDialog<String>(
      context: context,
      useSafeArea: false, //!!!!!!!!!!
      useRootNavigator: false,
      barrierColor: barrierColor,
      builder: (context) => FinalLevelOne(
        xOriginOffset: xOffset,
        yOriginOffset: yOffset,
        originWidth: width,
        items: items,
      ),
    );
  }

  final double xOriginOffset;
  final double yOriginOffset;
  final double originWidth;

  final Iterable<String> items;

  @override
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final expandedHeight = closeHeaderHeight + items.length * itemHeight;
      final topConstraint = AppBar().preferredSize.height + MediaQuery.of(context).padding.top + modalVerticalPaddinng;
      final bottomConstraint = MediaQuery.of(context).padding.bottom + modalVerticalPaddinng;

      //this one actually depends on how you want your expanded dropdown to behave
      final maxWidth = constraints.maxWidth - xOriginOffset - modalHorizontalPadding;

      var calculatedYOffset = yOriginOffset + collapsedHeight + modalVerticalPaddinng;
      final wouldOverflow = calculatedYOffset < topConstraint ||
          calculatedYOffset + expandedHeight > constraints.maxHeight - bottomConstraint;
      final maxExpandedHeight = wouldOverflow
          ? (constraints.maxHeight - yOriginOffset - modalVerticalPaddinng - collapsedHeight - bottomConstraint)
          : items.length * itemHeight + closeHeaderHeight + borderWidth;

      return Stack(
        children: [
          _positionChild(
            calculatedYOffset,
            xOriginOffset,
            maxExpandedHeight,
            maxWidth,
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth), child: _buildContent(context, maxExpandedHeight)),
          )
        ],
      );
    });
  }

  Widget _positionChild(
    double yOffset,
    double xOffset,
    double dropdownHeight,
    double maxWidth, {
    required Widget child,
  }) =>
      Positioned(
        top: yOffset,
        height: dropdownHeight,
        left: xOffset,
        child: child,
      );

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
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxExpandedHeight - closeHeaderHeight - borderWidth),
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
