import 'package:flutter/material.dart';
import 'package:passwd_hints/util/data_file_controller.dart';
import 'package:passwd_hints/util/rsa_cipher.dart';

import '../../../util/buttons_actions.dart';
import '../hint_entry_dialog.dart';

/// Hint entry dialog state : defines the state of a hint entry dialog,
/// particularly for editing an entry.
class HintEntryDialogState extends State<HintEntryDialog> {
  /// Name text field controller.
  late TextEditingController _nameController;

  /// Hint text field controller.
  late TextEditingController _hintController;

  /// Identifier text field controller.
  late TextEditingController _identifierController;

  late String _originalName;
  late String _originalHint;
  late String _originalIdentifier;

  /// Indicates if the name text field has been modified.
  bool _nameChanged = false;

  /// Indicates if the hint text field has been modified.
  bool _hintChanged = false;

  /// Indicates if the identifier text field has been modified.
  bool _identifierChanged = false;

  /// Indicates if the critical informations are visible.
  bool _criticalVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final cipher = RSACipherizer();
    _originalName = widget.entry.name;
    _originalHint = cipher.decipherMessage(widget.entry.hint);
    _originalIdentifier = widget.entry.identifier.isEmpty
        ? ''
        : cipher.decipherMessage(widget.entry.identifier);
    _nameController = TextEditingController(text: _originalName);
    _hintController = TextEditingController(text: _originalHint);
    _identifierController = TextEditingController(
      text: _originalIdentifier,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hintController.dispose();
    _identifierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Name must not be blank.";
              }
              if (value != _originalName &&
                  hintKeyAlreadyExisting(value, widget.entries)) {
                return "Hint name already exists.";
              }
              return null;
            },
            onChanged: (_) => _updateDirtyState(),
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Name *',
              prefixIcon: Icon(Icons.short_text),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _hintController,
            obscureText: !_criticalVisible,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Hint must not be blank.'
                : null,
            onChanged: (_) => _updateDirtyState(),
            autocorrect: false,
            enableSuggestions: false,
            decoration: const InputDecoration(
              labelText: 'Hint *',
              prefixIcon: Icon(Icons.key_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _identifierController,
            obscureText: !_criticalVisible,
            onChanged: (_) => _updateDirtyState(),
            decoration: const InputDecoration(
              labelText: 'Email or username',
              prefixIcon: Icon(Icons.alternate_email),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _criticalVisible = !_criticalVisible;
                  });
                },
                icon: Icon(
                  _criticalVisible ? Icons.visibility_off : Icons.visibility,
                ),
                label: Text(_criticalVisible ? 'Hide details' : 'Show details'),
              ),
              FilledButton.icon(
                onPressed: _nameChanged || _hintChanged || _identifierChanged
                    ? _saveChanges
                    : null,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Save'),
              ),
            ],
          ),
          if (_criticalVisible)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Sensitive details are visible',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  void _updateDirtyState() {
    setState(() {
      _nameChanged = _nameController.text != _originalName;
      _hintChanged = _hintController.text != _originalHint;
      _identifierChanged = _identifierController.text != _originalIdentifier;
    });
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = DataFileController();
    await controller.removeEntry(widget.entries, widget.entry.name);
    await controller.addEntry(
      widget.entries,
      _nameController.text.trim(),
      _hintController.text,
      _identifierController.text,
    );

    if (!mounted) {
      return;
    }
    _originalName = _nameController.text.trim();
    _originalHint = _hintController.text;
    _originalIdentifier = _identifierController.text;
    setState(() {
      _nameChanged = false;
      _hintChanged = false;
      _identifierChanged = false;
    });
    await widget.state.readEntries();
  }
}
