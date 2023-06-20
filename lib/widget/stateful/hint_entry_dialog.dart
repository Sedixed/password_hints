import 'package:flutter/material.dart';
import 'package:passwd_hints/util/hint_entry.dart';
import 'package:passwd_hints/widget/stateful/state/home_state.dart';

import 'state/hint_entry_dialog_state.dart';

/// Home widget : contains the state of the app.
class HintEntryDialog extends StatefulWidget {
  /// The hint entry the dialog is displaying.
  final HintEntry he;

  /// The app home state.
  final HomeState state;

  /// The entries list
  final List<HintEntry> entries;

  /// Default constructor.
  const HintEntryDialog(
    this.he,
    this.state,
    this.entries,
  );

  /// HintEntry getter
  get entry => he;

  /// Creates the home state.
  @override
  State<HintEntryDialog> createState() => HintEntryDialogState();
}
