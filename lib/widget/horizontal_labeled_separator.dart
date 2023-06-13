import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import '../constants.dart';

/// Horizontal labeled separator widget.
class HorizontalLabeledSeparator extends StatelessWidget {
  /// The entries of the application.
  final List entries;

  /// The current index of the entries to read.
  final int index;

  HorizontalLabeledSeparator(
    this.entries,
    this.index,
  );

  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    if (index == 0 ||
        (index > 0 &&
                index < entries.length &&
                entries[index - 1].name.isNotEmpty &&
                entries[index].name.isNotEmpty &&
                // first character is alpha
                (isAlpha(entries[index].name[0]) &&
                    entries[index - 1].name[0] != entries[index].name[0]) ||
            // first character is numeric
            (isFirstNumeric(index)) ||
            // first character is special
            (isFirstSpecial(index)))) {
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
              : getSeparatorLabel(entries[index].name)),
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

  /// returns the separator label according to the current [entryName].
  /// It will be from A-Z if it starts with an alpha character, 0 if it is a
  /// numeric character, or # if it is a special character.
  String getSeparatorLabel(String entryName) {
    if (isAlpha(entryName[0])) {
      return entryName[0];
    }
    if (isNumeric(entryName[0])) {
      return "0";
    }
    return "#";
  }

  /// Returns true if the entry name at [index] is the first entry readen which
  /// name starts with a digit, false otherwise.
  bool isFirstNumeric(int index) {
    if (isNumeric(entries[index].name[0])) {
      for (var i = 0; i < entries.length; ++i) {
        if (i == index) {
          continue;
        }
        if (isNumeric(entries[i].name[0]) &&
            (i == 0 || !isNumeric(entries[i - 1].name[0]))) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  /// Returns true if the entry name at [index] is the first entry readen which
  /// name starts with a special character, false otherwise.
  bool isFirstSpecial(int index) {
    if (!isAlphanumeric(entries[index].name[0])) {
      for (var i = 0; i < entries.length; ++i) {
        if (i == index) {
          continue;
        }
        if (!isAlphanumeric(entries[i].name[0]) &&
            (i == 0 || isAlphanumeric(entries[i - 1].name[0]))) {
          return false;
        }
      }
      return true;
    }
    return false;
  }
}
