import 'package:flutter/material.dart';

import '../constants.dart';
import '../decoration_util.dart';

class CustomDialogNoPosition extends StatelessWidget {
  const CustomDialogNoPosition({
    Key? key,
    required this.items,
  }) : super(key: key);

  static Future<String?> showItems<T>(
    BuildContext context,
    Iterable<String> items,
  ) {
    final barrierColor = Colors.white.withOpacity(0.7);

    return showDialog<String>(
      context: context,
      useSafeArea: false, //!!!!!!!!!!
      useRootNavigator: false,
      barrierColor: barrierColor,
      builder: (context) => CustomDialogNoPosition(
        items: items,
      ),
    );
  }

  final Iterable<String> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          Align(alignment: Alignment.center, child: _buildContent(context, MediaQuery.of(context).size.height)),
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
