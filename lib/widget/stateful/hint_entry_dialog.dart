import 'package:flutter/material.dart';
import 'package:passwd_hints/util/hint_entry.dart';
import 'package:passwd_hints/widget/stateful/state/home_state.dart';

import 'state/hint_entry_dialog_state.dart';

/// Home widget : contains the state of the app.
class HintEntryDialog extends StatefulWidget {
  /// The hint entry the dialog is displaying.
  final HintEntry _he;

  /// The app home state.
  final HomeState _state;

  /// The entries list
  final List<HintEntry> _entries;

  /// Default constructor.
  const HintEntryDialog(
    this._he,
    this._state,
    this._entries,
  );

  /// HintEntry getter
  HintEntry get entry => _he;

  /// HomeState getter
  HomeState get state => _state;

  /// Entries list getter
  List<HintEntry> get entries => _entries;

  /// Creates the home state.
  @override
  State<HintEntryDialog> createState() => HintEntryDialogState();
}
