import 'package:dialog_example/no_position/custom_dialog_no_position.dart';
import 'package:dialog_example/poistion_level_one/final_level_one.dart';
import 'package:dialog_example/position_level_two/final_level_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'constants.dart';
import 'decoration_util.dart';
import 'final/custom_dialog_final.dart';

class DialogButton extends StatefulWidget {
  const DialogButton({Key? key, required this.items, this.hint, this.selected, this.onChange}) : super(key: key);

  final List<String> items;
  final String? selected;
  final ValueChanged<String>? onChange;
  final String? hint;

  @override
  DialogButtonState createState() => DialogButtonState();
}

class DialogButtonState extends State<DialogButton> with SingleTickerProviderStateMixin {
  final _collapsedKey = GlobalKey(); //we need that to get position of the widget (RenderBox)
  var _isOpen = false;

  void _expand() async {
    setState(() {
      _isOpen = true;
    });

    // DropdownDialog.showItems(context, _collapsedKey, widget.items).then((selected) {
    //   setState(() {
    //     _isOpen = false;
    //   });
    //   if (selected != null && widget.onChange != null) {
    //     widget.onChange!(selected);
    //   }
    // });

    CustomDialogNoPosition.showItems(context, widget.items).then((selected) {
      setState(() {
        _isOpen = false;
      });
      if (selected != null && widget.onChange != null) {
        widget.onChange!(selected);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(key: _collapsedKey, onTap: _expand, child: _buildCollapsed());
  }

  Widget _buildCollapsed() {
    return Container(
      height: collapsedHeight,
      decoration: DecorationUtil.getDecoration(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
    );
  }
}
