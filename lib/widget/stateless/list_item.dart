import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../util/buttons_actions.dart';

/// Handles the display and behaviour of a list item, eq. an entry.
class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    required this.entries,
    required this.index,
  }) : super(key: key);

  /// The entries of the application.
  final List entries;

  /// The current index of the entries to read.
  final int index;

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
                // handle overflow
                onPressed: () {
                  hintEntryDisplayButtonOnPress(context, entries[index - 1]);
                },
                child: Text(entries[index - 1].name,
                    style: const TextStyle(fontSize: 20)),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.remove_circle_outline,
                color: entryRemovingColor,
              ),
              onPressed: () {
                confirmEntryDeletionButtonOnPress(
                    context, entries[index - 1].name);
              },
            )
          ],
        ),
      ),
    );
  }
}
