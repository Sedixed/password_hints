import 'package:flutter/material.dart';
import 'package:passwd_hints/constants.dart';

import '../hint_entry_dialog.dart';

class HintEntryDialogState extends State<HintEntryDialog> {
  late TextEditingController nameController;
  FocusNode nameFocus = FocusNode();
  late TextEditingController hintController;
  FocusNode hintFocus = FocusNode();
  late TextEditingController identifierController;
  FocusNode identifierFocus = FocusNode();

  bool nameChanged = false;
  bool hintChanged = false;
  bool identifierChanged = false;

  @override
  HintEntryDialog get widget => super.widget;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.entry.name);
    hintController = TextEditingController(text: widget.entry.hint);
    identifierController = TextEditingController(text: widget.entry.identifier);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: nameController,
              focusNode: nameFocus,
              onChanged: (newValue) =>
                  onEditionStep(newValue, widget.entry.name, nameRef),
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
              controller: hintController,
              focusNode: hintFocus,
              onChanged: (newValue) =>
                  onEditionStep(newValue, widget.entry.hint, hintRef),
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
                controller: identifierController,
                focusNode: identifierFocus,
                onChanged: (newValue) => onEditionStep(
                    newValue, widget.entry.identifier, identifierRef),
                decoration: InputDecoration(
                  labelText: 'Email/Username',
                  icon: Icon(Icons.alternate_email),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: nameChanged || hintChanged || identifierChanged
                    ? () {
                        print('enabled');
                      }
                    : null,
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onEditionStep(String newValue, String oldValue, String fieldRef) {
    setState(() {
      switch (fieldRef) {
        case nameRef:
          nameChanged = newValue != oldValue;
          break;
        case hintRef:
          hintChanged = newValue != oldValue;
          break;
        case identifierRef:
          identifierChanged = newValue != oldValue;
          break;
        default:
          break;
      }
    });
  }
}
