import 'package:flutter/material.dart';
import '../constants.dart';

class HorizontalLabeledSeparator extends StatelessWidget {
  final List entries;
  final int index;

  HorizontalLabeledSeparator(
    this.entries,
    this.index,
  );

  @override
  Widget build(BuildContext context) {
    if (index == 0 ||
        (index > 0 &&
            index < entries.length &&
            entries[index - 1].name.isNotEmpty &&
            entries[index].name.isNotEmpty &&
            entries[index - 1].name[0] != entries[index].name[0])) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 10.0),
              child: Divider(
                color: sepColor,
                thickness: 2,
              ),
            ),
          ),
          Text(entries[index].name.isEmpty
              ? 'SAMPLE TEXT'
              : entries[index].name[0]),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10.0),
              child: Divider(
                color: sepColor,
                thickness: 2,
              ),
            ),
          ),
        ],
      );
    }
    return SizedBox();
  }
}
