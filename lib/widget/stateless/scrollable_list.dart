import 'package:flutter/material.dart';
import 'package:passwd_hints/util/hint_entry.dart';
import 'package:passwd_hints/widget/stateful/state/home_state.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
      return EmptyListCard();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 40, 20),
      child: ScrollablePositionedList.separated(
        separatorBuilder: (context, index) => HorizontalLabeledSeparator(
          _entries,
          index,
        ),
        itemScrollController: _itemScrollController,
        itemPositionsListener: _itemPositionsListener,
        itemCount: _entries.length + 1,
        itemBuilder: (context, index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            index == 0
                ? SizedBox()
                : ListItem(
                    _entries,
                    index,
                    _homeState,
                  ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
