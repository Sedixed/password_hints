import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import '../../constants.dart';

/// Horizontal labeled separator widget.
class HorizontalLabeledSeparator extends StatelessWidget {
  /// The entries of the application.
  final List _entries;

  /// The current index of the entries to read.
  final int _index;

  HorizontalLabeledSeparator(
    this._entries,
    this._index,
  );

  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    if (_index == 0 ||
        (_index > 0 &&
                _index < _entries.length &&
                _entries[_index - 1].name.isNotEmpty &&
                _entries[_index].name.isNotEmpty &&
                // first character is alpha
                (isAlpha(_entries[_index].name[0]) &&
                    _entries[_index - 1].name[0].toLowerCase() !=
                        _entries[_index].name[0].toLowerCase()) ||
            // first character is numeric
            (isFirstNumeric(_index)) ||
            // first character is special
            (isFirstSpecial(_index)))) {
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
          Text(_entries[_index].name.isEmpty
              ? 'SAMPLE TEXT'
              : getSeparatorLabel(_entries[_index].name)),
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
      return entryName[0].toUpperCase();
    }
    if (isNumeric(entryName[0])) {
      return "0";
    }
    return "#";
  }

  /// Returns true if the entry name at [index] is the first entry readen which
  /// name starts with a digit, false otherwise.
  bool isFirstNumeric(int index) {
    if (isNumeric(_entries[index].name[0])) {
      for (var i = 0; i < _entries.length; ++i) {
        if (i == index) {
          continue;
        }
        if (isNumeric(_entries[i].name[0]) &&
            (i == 0 || !isNumeric(_entries[i - 1].name[0]))) {
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
    if (!isAlphanumeric(_entries[index].name[0])) {
      for (var i = 0; i < _entries.length; ++i) {
        if (i == index) {
          continue;
        }
        if (!isAlphanumeric(_entries[i].name[0]) &&
            (i == 0 || isAlphanumeric(_entries[i - 1].name[0]))) {
          return false;
        }
      }
      return true;
    }
    return false;
  }
}
