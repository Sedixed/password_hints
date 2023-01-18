import 'package:flutter/material.dart';
import '../constants.dart';

class HorizontalLabeledSeparator extends StatelessWidget {
  final List names;
  final int index;

  HorizontalLabeledSeparator(
    this.names,
    this.index,
  );

  @override
  Widget build(BuildContext context) {
    if (index == 0 ||
        index > 0 &&
            index < names.length &&
            names[index - 1][0] != names[index][0]) {
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
          Text(names[index][0]),
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
