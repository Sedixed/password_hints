import 'package:flutter/material.dart';
import 'package:passwd_hints/util/data_file_controller.dart';
import 'package:passwd_hints/util/hint_entry.dart';
import 'package:passwd_hints/widget/stateful/hint_entry_dialog.dart';
import 'package:passwd_hints/widget/stateful/new_hint_dialog.dart';
import 'package:passwd_hints/widget/stateful/state/home_state.dart';

/// Returns true if an entry named [entryName] exists in [entries], false
/// otherwise.
bool hintKeyAlreadyExisting(String entryName, List<HintEntry> entries) {
  for (var entry in entries) {
    if (entry.name == entryName) {
      return true;
    }
  }
  return false;
}

/// Opens the form for creating an entry.
void hintEntryAdditionButtonOnPress(
  BuildContext context,
  HomeState caller,
  List<HintEntry> entries,
) {
  showDialog<void>(
    context: context,
    builder: (_) => NewHintDialog(
      caller: caller,
      entries: entries,
    ),
  );
}

/// Opens a confirmation dialog before deleting [name].
void confirmEntryDeletionButtonOnPress(
  BuildContext context,
  List<HintEntry> entries,
  String name,
  HomeState state,
) {
  final controller = DataFileController();
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(Icons.delete_outline),
      title: const Text('Delete hint?'),
      content: Text('Delete “$name”? This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(dialogContext).colorScheme.error,
            foregroundColor: Theme.of(dialogContext).colorScheme.onError,
          ),
          onPressed: () async {
            await controller.removeEntry(entries, name);
            if (!dialogContext.mounted) {
              return;
            }
            Navigator.pop(dialogContext);
            await state.readEntries();
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}

/// Opens the detail and edit dialog for [entry].
void hintEntryDisplayButtonOnPress(
  BuildContext context,
  List<HintEntry> entries,
  HintEntry entry,
  HomeState state,
) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      scrollable: true,
      title: const Text('Hint details'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: HintEntryDialog(
          entry,
          state,
          entries,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Done'),
        ),
      ],
    ),
  );
}
