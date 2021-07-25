import 'package:dialog_example/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'constants.dart';
import 'decoration_util.dart';

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

    CustomDialog.showItems(context, widget.items).then((value) {
      setState(() {
        _isOpen = false;
      });
      if (value != null && widget.onChange != null) {
        widget.onChange!(value);
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
