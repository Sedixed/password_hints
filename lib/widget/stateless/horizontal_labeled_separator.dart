import 'package:flutter/material.dart';
import 'package:passwd_hints/util/hint_entry.dart';
import 'package:string_validator/string_validator.dart';

/// Displays a labeled divider at the start of each alphabetic group.
class HorizontalLabeledSeparator extends StatelessWidget {
  const HorizontalLabeledSeparator(
    this._entries,
    this._index, {
    super.key,
  });

  final List<HintEntry> _entries;
  final int _index;

  @override
  Widget build(BuildContext context) {
    if (_index > 0 &&
        _getSeparatorLabel(_entries[_index - 1].name) ==
            _getSeparatorLabel(_entries[_index].name)) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: colorScheme.outlineVariant, height: 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              _getSeparatorLabel(_entries[_index].name),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          Expanded(
            child: Divider(color: colorScheme.outlineVariant, height: 1),
          ),
        ],
      ),
    );
  }

  String _getSeparatorLabel(String name) {
    final firstCharacter = name[0];
    if (isAlpha(firstCharacter)) {
      return firstCharacter.toUpperCase();
    }
    if (isNumeric(firstCharacter)) {
      return '0';
    }
    return '#';
  }
}
