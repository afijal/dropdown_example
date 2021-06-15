import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

part 'closeable_dropdown_route_no_position.dart';

class CloseableDropdownNoPosition extends StatefulWidget {
  const CloseableDropdownNoPosition({Key? key, required this.items, this.hint, this.selected, this.onChange})
      : super(key: key);

  final List<String> items;
  final String? selected;
  final ValueChanged<String>? onChange;
  final String? hint;

  @override
  _CloseableDropdownNoPositionState createState() => _CloseableDropdownNoPositionState();
}

class _CloseableDropdownNoPositionState extends State<CloseableDropdownNoPosition> with SingleTickerProviderStateMixin {
  static const _collapsedHeight = 36.0;
  static const _itemHeight = 44.0;
  static const _closeHeaderHeight = 48.0;
  static const _sidePadding = 16.0;

  final _collapsedKey = GlobalKey(); //we need that to get position of the widget (RenderBox)
  var _isOpen = false;
  _CloseableDropdownRouteNoPosition? _popupRoute;

  void _expand() {
    _popupRoute = _CloseableDropdownRouteNoPosition(
      child: LayoutBuilder(builder: (context, constraints) {
        return _buildExpanded();
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

  Widget _buildExpanded() {
    return Material(
      child: Container(
        decoration: _getDecoration(),
        //child: IntrinsicWidth(
        //this makes sure that dropdown is as wide as it need to be
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildExpandedHeader(),
            _buildExpandedItems(),
          ],
        ),
        //  ),
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
  Widget _buildExpandedItems() {
    return SingleChildScrollView(
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
