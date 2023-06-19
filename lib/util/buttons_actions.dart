import 'package:flutter/material.dart';
import 'package:passwd_hints/util/colors/app_colors.dart';
import 'package:passwd_hints/util/hint_entry.dart';
import 'package:passwd_hints/util/theme_mode.dart';
import 'package:passwd_hints/widget/stateful/hint_entry_dialog.dart';
import 'package:passwd_hints/widget/stateful/state/home_state.dart';

void hintEntryAdditionButtonOnPress(
    BuildContext context, HomeState caller, List<HintEntry> entries) {
  TextEditingController nameController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  TextEditingController hintController = TextEditingController();
  FocusNode hintFocus = FocusNode();
  TextEditingController identifierController = TextEditingController();
  FocusNode identifierFocus = FocusNode();

  bool hintKeyAlreadyExisting(String entryName, List<HintEntry> entries) {
    for (var entry in entries) {
      if (entry.name == entryName) {
        return true;
      }
    }
    return false;
  }

  final formKey = GlobalKey<FormState>();

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Text('New hint'),
          content: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  focusNode: nameFocus,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name must not be blank.";
                    }
                    if (hintKeyAlreadyExisting(value, entries)) {
                      return "Hint name already existing.";
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Hint must not be blank.";
                    }
                    return null;
                  },
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
                  decoration: InputDecoration(
                    labelText: 'Email/Username',
                    icon: Icon(Icons.alternate_email),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 22.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: context.isDarkMode
                            ? AppColor.darkButtonColor.color
                            : AppColor.buttonColor.color),
                    child: Text('Add'),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        caller.addEntry(nameController.text,
                            hintController.text, identifierController.text);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      });
}

void confirmEntryDeletionButtonOnPress(BuildContext context, String name) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Text(
                'Delete entry "$name" ?',
                style: const TextStyle(fontSize: 20),
              ),
            ]),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                print('confirmed');
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.removalButtonColor.color,
                  foregroundColor: AppColor.white.color),
              child: Text('Yes'),
            ),
            ElevatedButton(
              autofocus: true,
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.isDarkMode
                    ? AppColor.darkHeavyButtonColor.color
                    : AppColor.heavyButtonColor.color,
              ),
              child: Text('No'),
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      });
}

void hintEntryDisplayButtonOnPress(BuildContext context, HintEntry entry) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Text(entry.name),
          content: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return HintEntryDialog(he: entry);
            },
          ),
        );
      });
}
