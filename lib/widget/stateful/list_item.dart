import 'package:flutter/material.dart';
import 'package:passwd_hints/util/hint_entry.dart';
import 'package:passwd_hints/widget/stateful/state/home_state.dart';

import 'state/list_item_state.dart';

/// Handles the display and behaviour of a list item, eq. an entry.
class ListItem extends StatefulWidget {
  const ListItem(this._entries, this._index, this._homeState);

  /// The entries of the application.
  final List<HintEntry> _entries;

  /// The current index of the entries to read.
  final int _index;

  /// The home state.
  final HomeState _homeState;

  /// Entries list getter
  List<HintEntry> get entries => _entries;

  /// Index getter
  int get index => _index;

  /// HomeState getter
  HomeState get homeState => _homeState;

  /// Creates the ListItem state.
  @override
  State<ListItem> createState() => ListItemState();
}
