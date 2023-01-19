import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'empty_list_card.dart';
import 'horizontal_labeled_separator.dart';
import 'list_item.dart';

class ScrollableList extends StatelessWidget {
  List entries;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;

  ScrollableList(
      this.entries, this.itemScrollController, this.itemPositionsListener);

  @override
  Widget build(BuildContext context) {
    print('CA CONSTRUIT LA LISTE');
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
