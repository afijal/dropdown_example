import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'closeable_dropdown_layout.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({Key? key, required this.items, this.hint, this.selected, this.onChange}) : super(key: key);

  final List<String> items;
  final String? selected;
  final ValueChanged<String>? onChange;
  final String? hint;

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> with SingleTickerProviderStateMixin {
  static const _collapsedHeight = 36.0;
  static const _itemHeight = 44.0;
  static const _closeHeaderHeight = 48.0;
  static const _sidePadding = 16.0;

  final _collapsedKey = GlobalKey(); //we need that to get position of the widget (RenderBox)
  var _isOpen = false;
  _CloseableDropdownRoute? _popupRoute;

  void _expand() {
    //TODO: create route and show it

    setState(() {
      _isOpen = true;
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
