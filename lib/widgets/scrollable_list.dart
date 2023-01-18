import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'empty_list_card.dart';
import 'horizontal_labeled_separator.dart';

class ScrollableList extends StatelessWidget {
  final List names;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;

  ScrollableList(
      this.names, this.itemScrollController, this.itemPositionsListener);

  @override
  Widget build(BuildContext context) {
    if (names.isEmpty) {
      return EmptyListCard();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 40, 20),
      child: ScrollablePositionedList.separated(
        separatorBuilder: (context, index) =>
            HorizontalLabeledSeparator(names, index),
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        itemCount: names.length + 1,
        itemBuilder: (context, index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            index == 0
                ? SizedBox()
                : Container(
                    width: double.infinity,
                    height: 50,
                    child: Card(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            names[index - 1],
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
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
