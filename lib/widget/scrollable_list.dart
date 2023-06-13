import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'empty_list_card.dart';
import 'horizontal_labeled_separator.dart';
import 'list_item.dart';

/// Scrollable entries list.
class ScrollableList extends StatelessWidget {
  /// Entries of the application.
  final List entries;

  /// Item scroll controller.
  final ItemScrollController itemScrollController;

  /// Item positions listener.
  final ItemPositionsListener itemPositionsListener;

  ScrollableList(
      this.entries, this.itemScrollController, this.itemPositionsListener);

  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return EmptyListCard();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 40, 20),
      child: ScrollablePositionedList.separated(
        separatorBuilder: (context, index) =>
            HorizontalLabeledSeparator(entries, index),
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        itemCount: entries.length + 1,
        itemBuilder: (context, index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            index == 0 ? SizedBox() : ListItem(entries: entries, index: index),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
