import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'closeable_dropdown_layout.dart';

part 'closeable_dropdown_route.dart';

class CloseableDropdown extends StatefulWidget {
  const CloseableDropdown({Key? key, required this.items, this.hint, this.selected, this.onChange}) : super(key: key);

  final List<String> items;
  final String? selected;
  final ValueChanged<String>? onChange;
  final String? hint;

  @override
  _CloseableDropdownState createState() => _CloseableDropdownState();
}

class _CloseableDropdownState extends State<CloseableDropdown> with SingleTickerProviderStateMixin {
  static const _collapsedHeight = 36.0;
  static const _itemHeight = 44.0;
  static const _closeHeaderHeight = 48.0;
  static const _sidePadding = 16.0;

  final _collapsedKey = GlobalKey(); //we need that to get position of the widget (RenderBox)
  var _isOpen = false;
  _CloseableDropdownRoute? _popupRoute;

  void _expand() {
    _popupRoute = _CloseableDropdownRoute(
      child: LayoutBuilder(builder: (context, constraints) {
        final renderBox = _collapsedKey.currentContext?.findRenderObject() as RenderBox;
        final yOffset = renderBox.localToGlobal(Offset.zero).dy;
        final xOffset = renderBox.localToGlobal(Offset.zero).dx;
        final overlapYOffset = 12; //so that modal doesn't cover collapsed button
        final expandedHeight = _closeHeaderHeight + widget.items.length * _itemHeight;
        final topConstraint = AppBar().preferredSize.height + MediaQuery.of(context).padding.top + overlapYOffset;
        final bottomConstraint = MediaQuery.of(context).padding.bottom + overlapYOffset;
        //this one actually depends on how you want your expanded dropdown to behave,w e want it to be as wide as it needs so let's just give it a max so it does not overflows
        final maxWidth = min(constraints.maxWidth, renderBox.size.width);
        //yoffset is from top so we do not need to take appbar or safeare into consideration
        //just check whether it wouldnt fit and if is in lowe bottom of screen
        final showAtTop = expandedHeight > constraints.maxHeight - yOffset && yOffset > constraints.maxHeight / 2;
        final calculatedYOffset =
            showAtTop ? yOffset - expandedHeight - overlapYOffset : yOffset + _collapsedHeight + overlapYOffset;
        final wouldOverflow = calculatedYOffset < topConstraint ||
            calculatedYOffset + expandedHeight > constraints.maxHeight - bottomConstraint;
        final maxExpandedHeight = wouldOverflow
            ? (showAtTop
                ? yOffset - topConstraint - overlapYOffset
                : constraints.maxHeight - yOffset - overlapYOffset - _collapsedHeight - bottomConstraint)
            : widget.items.length * _itemHeight + _closeHeaderHeight;

        return CustomSingleChildLayout(
          delegate: CloseableDropdownLayout(
              yOffset: wouldOverflow && showAtTop ? topConstraint : calculatedYOffset,
              xOffset: xOffset,
              textDirection: Directionality.maybeOf(context)!,
              maxHeight: constraints.maxHeight,
              maxWidth: maxWidth),
          child: _buildExpanded(maxExpandedHeight),
        );
      }),
    );

    setState(() {
      _isOpen = true;
    });

    Navigator.of(context).push(_popupRoute!).then<void>((newValue) {
      setState(() {
        _isOpen = false;
      });
      _popupRoute = null;
      if (!mounted || newValue == null) return;
      if (widget.onChange != null) {
        widget.onChange!(newValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _collapsedKey,
      child: GestureDetector(onTap: _expand, child: _buildCollapsed()),
    );
  }

  Widget _buildCollapsed() {
    return Container(
      decoration: _getDecoration(),
      child: SizedBox(
        height: _collapsedHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _sidePadding),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                widget.selected == null ? widget.hint ?? '' : widget.selected!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )),
              Icon(
                _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpanded(double maxExpandedHeight) {
    return Material(
      child: Container(
        decoration: _getDecoration(),
        child: IntrinsicWidth(
          //this makes sure that dropdown is as wide as it need to be
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildExpandedHeader(),
              _buildExpandedItems(maxExpandedHeight - _closeHeaderHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedHeader() {
    return SizedBox(
      height: _closeHeaderHeight,
      child: Row(
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
  Widget _buildExpandedItems(double maxHeight) {
    return SizedBox(
      height: maxHeight,
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: widget.items
                .map(
                  (e) => Material(
                    color: Colors.transparent,
                    child: InkWell(
                      //we want a feedback that the item was clicked
                      onTap: () => Navigator.of(context).pop(e),
                      child: SizedBox(
                          height: _itemHeight,
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
      ),
    );
  }

  BoxDecoration _getDecoration() {
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
