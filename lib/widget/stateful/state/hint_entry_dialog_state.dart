import 'package:flutter/material.dart';
import 'package:passwd_hints/constants.dart';
import 'package:passwd_hints/util/colors/app_colors.dart';
import 'package:passwd_hints/util/data_file_controller.dart';
import 'package:passwd_hints/util/theme_mode.dart';

import '../../../util/buttons_actions.dart';
import '../hint_entry_dialog.dart';

/// Hint entry dialog state : defines the state of a hint entry dialog,
/// particularly for editing an entry.
class HintEntryDialogState extends State<HintEntryDialog> {
  /// Name text field controller.
  late TextEditingController _nameController;

  /// Name text field focus node.
  FocusNode _nameFocus = FocusNode();

  /// Hint text field controller.
  late TextEditingController _hintController;

  /// Hint text field focus node.
  FocusNode _hintFocus = FocusNode();

  /// Identifier text field controller.
  late TextEditingController _identifierController;

  /// Identifier text field focus node.
  FocusNode _identifierFocus = FocusNode();

  /// Indicates if the name text field has been modified.
  bool _nameChanged = false;

  /// Indicates if the hint text field has been modified.
  bool _hintChanged = false;

  /// Indicates if the identifier text field has been modified.
  bool _identifierChanged = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.entry.name);
    _hintController = TextEditingController(text: widget.entry.hint);
    _identifierController = TextEditingController(
      text: widget.entry.identifier,
    );
  }

  @override
  Widget build(BuildContext context) {
    DataFileController dfc = DataFileController();

    return Form(
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            focusNode: _nameFocus,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Name must not be blank.";
              }
              if (hintKeyAlreadyExisting(value, widget.entries)) {
                return "Hint name already existing.";
              }
              return null;
            },
            onChanged: (newValue) => onEditionStep(
              newValue,
              widget.entry.name,
              nameRef,
            ),
            decoration: InputDecoration(
              labelText: 'Name',
              suffixText: '  *',
              suffixStyle: TextStyle(
                color: Colors.red,
              ),
              icon: Icon(Icons.short_text),
            ),
          ),
          TextFormField(
            controller: _hintController,
            focusNode: _hintFocus,
            onChanged: (newValue) => onEditionStep(
              newValue,
              widget.entry.hint,
              hintRef,
            ),
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: 'Hint',
              suffixText: '  *',
              suffixStyle: TextStyle(
                color: Colors.red,
              ),
              icon: Icon(Icons.remove_red_eye),
            ),
          ),
          TextFormField(
            controller: _identifierController,
            focusNode: _identifierFocus,
            onChanged: (newValue) => onEditionStep(
              newValue,
              widget.entry.identifier,
              identifierRef,
            ),
            decoration: InputDecoration(
              labelText: 'Email/Username',
              icon: Icon(Icons.alternate_email),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 22.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(15),
                  foregroundColor: AppColor.white.color,
                  backgroundColor: context.isDarkMode
                      ? AppColor.darkEditButtonColor.color
                      : AppColor.editButtonColor.color,
                ),
                onPressed: _nameChanged || _hintChanged || _identifierChanged
                    ? () {
                        dfc.removeEntry(widget.entries, widget.entry.name);
                        dfc.addEntry(
                          widget.entries,
                          _nameController.text,
                          _hintController.text,
                          _identifierController.text,
                        );
                        Navigator.pop(context);
                        widget.state.setState(() {
                          widget.state.readEntries();
                        });
                      }
                    : null,
                child: Icon(Icons.save),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Updates the boolean indicating if a field has been modified at each
  /// edition step (eq. a field has been edited).
  onEditionStep(String newValue, String oldValue, String fieldRef) {
    setState(() {
      switch (fieldRef) {
        case nameRef:
          _nameChanged = newValue != oldValue;
          break;
        case hintRef:
          _hintChanged = newValue != oldValue;
          break;
        case identifierRef:
          _identifierChanged = newValue != oldValue;
          break;
        default:
          break;
      }
    });
  }
}
