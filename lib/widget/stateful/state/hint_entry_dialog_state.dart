import 'package:flutter/material.dart';
import 'package:passwd_hints/constants.dart';
import 'package:passwd_hints/util/colors/app_colors.dart';
import 'package:passwd_hints/util/theme_mode.dart';

import '../hint_entry_dialog.dart';

class HintEntryDialogState extends State<HintEntryDialog> {
  late TextEditingController _nameController;
  FocusNode _nameFocus = FocusNode();
  late TextEditingController _hintController;
  FocusNode _hintFocus = FocusNode();
  late TextEditingController _identifierController;
  FocusNode _identifierFocus = FocusNode();

  bool _nameChanged = false;
  bool _hintChanged = false;
  bool _identifierChanged = false;

  @override
  HintEntryDialog get widget => super.widget;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.entry.name);
    _hintController = TextEditingController(text: widget.entry.hint);
    _identifierController =
        TextEditingController(text: widget.entry.identifier);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            focusNode: _nameFocus,
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
            controller: _hintController,
            focusNode: _hintFocus,
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
              controller: _identifierController,
              focusNode: _identifierFocus,
              onChanged: (newValue) => onEditionStep(
                  newValue, widget.entry.identifier, identifierRef),
              decoration: InputDecoration(
                labelText: 'Email/Username',
                icon: Icon(Icons.alternate_email),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 22.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: context.isDarkMode
                        ? AppColor.darkButtonColor.color
                        : AppColor.buttonColor.color),
                onPressed: _nameChanged || _hintChanged || _identifierChanged
                    ? () {
                        print('enabled');
                      }
                    : null,
                child: Text('Save'),
              ),
            ),
          )
        ],
      ),
    );
  }

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
