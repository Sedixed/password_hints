import 'package:flutter/material.dart';

import '../../../util/buttons_actions.dart';
import '../list_item.dart';

/// Defines the state of a list item (for item removing and editing).
class ListItemState extends State<ListItem> {
  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    final entry = widget.entries[widget.index];
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(16),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16, right: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        leading: CircleAvatar(
          backgroundColor: colorScheme.secondaryContainer,
          foregroundColor: colorScheme.onSecondaryContainer,
          child: Text(
            entry.name.characters.first.toUpperCase(),
            semanticsLabel: 'Entry initial',
          ),
        ),
        title: Text(
          entry.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => hintEntryDisplayButtonOnPress(
          context,
          widget.entries,
          entry,
          widget.homeState,
        ),
        trailing: IconButton(
          tooltip: 'Delete ${entry.name}',
          icon: Icon(
            Icons.delete_outline,
            color: colorScheme.error,
          ),
          onPressed: () => confirmEntryDeletionButtonOnPress(
            context,
            widget.entries,
            entry.name,
            widget.homeState,
          ),
        ),
      ),
    );
  }
}
