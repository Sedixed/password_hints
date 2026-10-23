import 'package:flutter/material.dart';
import 'package:passwd_hints/util/hint_entry.dart';
import 'package:passwd_hints/widget/stateful/state/home_state.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../util/buttons_actions.dart';
import 'empty_list_card.dart';
import 'horizontal_labeled_separator.dart';
import '../stateful/list_item.dart';

/// Scrollable entries list.
class ScrollableList extends StatelessWidget {
  /// Entries of the application.
  final List<HintEntry> _entries;

  /// Item scroll controller.
  final ItemScrollController _itemScrollController;

  /// Item positions listener.
  final ItemPositionsListener _itemPositionsListener;

  /// The home state
  final HomeState _homeState;

  /// Default constructor
  ScrollableList(
    this._entries,
    this._itemScrollController,
    this._itemPositionsListener,
    this._homeState,
  );

  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    if (_entries.isEmpty) {
      return EmptyListCard(
        onAddHint: () => hintEntryAdditionButtonOnPress(
          context,
          _homeState,
          _entries,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
      child: ScrollablePositionedList.builder(
        itemScrollController: _itemScrollController,
        itemPositionsListener: _itemPositionsListener,
        itemCount: _entries.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HorizontalLabeledSeparator(_entries, index),
              ListItem(
                _entries,
                index,
                _homeState,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
