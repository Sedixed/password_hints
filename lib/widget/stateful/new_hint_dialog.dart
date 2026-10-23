import 'package:flutter/material.dart';
import 'package:passwd_hints/util/buttons_actions.dart';
import 'package:passwd_hints/util/hint_entry.dart';
import 'package:passwd_hints/widget/stateful/state/home_state.dart';

/// Dialog for creating a hint entry.
class NewHintDialog extends StatefulWidget {
  const NewHintDialog({
    required this.caller,
    required this.entries,
    super.key,
  });

  final HomeState caller;
  final List<HintEntry> entries;

  @override
  State<NewHintDialog> createState() => _NewHintDialogState();
}

class _NewHintDialogState extends State<NewHintDialog> {
  final _nameController = TextEditingController();
  final _hintController = TextEditingController();
  final _identifierController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _hintController.dispose();
    _identifierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('New hint'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name must not be blank.';
                }
                if (hintKeyAlreadyExisting(value, widget.entries)) {
                  return 'Hint name already exists.';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.short_text),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _hintController,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Hint must not be blank.';
                }
                return null;
              },
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                labelText: 'Hint',
                prefixIcon: Icon(Icons.key_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _identifierController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Email or username',
                prefixIcon: Icon(Icons.alternate_email),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _addEntry,
          child: const Text('Add hint'),
        ),
      ],
    );
  }

  Future<void> _addEntry() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await widget.caller.addEntry(
      _nameController.text.trim(),
      _hintController.text,
      _identifierController.text,
    );
    if (mounted) {
      Navigator.pop(context);
    }
  }
}
