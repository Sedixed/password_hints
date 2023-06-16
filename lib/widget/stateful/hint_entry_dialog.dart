import 'package:flutter/material.dart';
import 'package:passwd_hints/util/hint_entry.dart';

import 'state/hint_entry_dialog_state.dart';

/// Home widget : contains the state of the app.
class HintEntryDialog extends StatefulWidget {
  /// The hint entry the dialog is displaying.
  final HintEntry he;

  const HintEntryDialog({super.key, required this.he});

  /// HintEntry getter
  get entry => he;

  /// Creates the home state.
  @override
  State<HintEntryDialog> createState() => HintEntryDialogState();
}
