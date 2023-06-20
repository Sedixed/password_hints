import 'package:flutter/material.dart';
import 'package:passwd_hints/util/hint_entry.dart';
import 'package:passwd_hints/widget/stateful/state/home_state.dart';

import 'state/list_item_state.dart';

/// Handles the display and behaviour of a list item, eq. an entry.
class ListItem extends StatefulWidget {
  const ListItem(this.entries, this.index, this.homeState);

  /// The entries of the application.
  final List<HintEntry> entries;

  /// The current index of the entries to read.
  final int index;

  /// The home state.
  final HomeState homeState;

  /// Creates the ListItem state.
  @override
  State<ListItem> createState() => ListItemState();
}
