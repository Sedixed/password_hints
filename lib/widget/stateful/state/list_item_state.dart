import 'package:flutter/material.dart';

import '../../../util/buttons_actions.dart';
import '../../../util/colors/app_colors.dart';
import '../list_item.dart';

/// Defines the state of a list item (for item removing and editing).
class ListItemState extends State<ListItem> {
  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextButton(
                onPressed: () {
                  hintEntryDisplayButtonOnPress(
                    context,
                    widget.entries,
                    widget.entries[widget.index - 1],
                    widget.homeState,
                  );
                },
                child: Text(
                  widget.entries[widget.index - 1].name,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.remove_circle_outline,
                color: AppColor.darkEntryRemovingColor.color,
              ),
              onPressed: () {
                confirmEntryDeletionButtonOnPress(
                  context,
                  widget.entries,
                  widget.entries[widget.index - 1].name,
                  widget.homeState,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
