import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:string_validator/string_validator.dart';

import '../../../util/app_search_delegate.dart';
import '../../../util/buttons_actions.dart';
import '../home.dart';
import '../../../constants.dart';
import '../../../util/data_file_controller.dart';
import '../../../util/hint_entry.dart';

import '../../stateless/scrollable_list.dart';

import 'package:faker/faker.dart';

// faking
const nb = 20;
Faker faker = Faker();
List<String> names = List<String>.generate(
    nb, (index) => faker.person.firstName(),
    growable: true);
List<String> hints = List<String>.generate(
    nb, (index) => faker.lorem.sentence(),
    growable: true);
List<String> ids =
    List<String>.generate(nb, (index) => faker.guid.guid(), growable: true);

/// HomeState widget : defines the state of the app.
class HomeState extends State<Home> {
  // Alphabet
  final alphabets = List.generate(
      26, (index) => String.fromCharCode(index + firstLetterIndex));

  // Search index (right panel)
  int _searchIndex = 0;

  // Hint entries
  List<HintEntry> entries = [];

  // Scroll controllers / jumpers
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  // File controller
  final DataFileController controller = DataFileController();

  // Loading toggle
  bool isLoading = false;

  /// Initializes the home state by reading the data file and adding the missing
  /// alphabet elements (0 for numeric and # for special characters).
  @override
  void initState() {
    print('init');
    isLoading = true;
    alphabets.add('0');
    alphabets.add('#');
    super.initState();

    // faking
    for (var i = 0; i < nb; ++i) {
      addEntry(names[i], hints[i], ids[i]);
    }

    controller.readEntries(entries).then(
      (value) {
        setState(() {
          isLoading = false;
          print(entries.length);
        });
      },
    );
  }

  /// Sets the search index after a tap on searchLetter on the screen.
  /// If a matching entry is directly found, jumps to it. Otherwise, it
  /// reads the next entries and jumps to the first found. If there is no entry
  /// after the searched one, no jump is performed.
  void setSearchIndex(String searchLetter) {
    setState(() {
      _searchIndex = entries.indexWhere((element) =>
          element.name.isNotEmpty &&
          (element.name[0] == searchLetter ||
              (isNumeric(element.name[0]) && searchLetter == "0") ||
              (!isAlphanumeric(element.name[0]) && searchLetter == "#")));
      // Entry directly found
      if (_searchIndex >= 0) {
        _itemScrollController.jumpTo(index: _searchIndex);
        // Entry not found : investigating next letters
      } else {
        var i = 0;
        var asciiLetter = searchLetter.codeUnitAt(0);
        while (_searchIndex < 0) {
          if (i + asciiLetter > firstLetterIndex + zIndex) {
            break;
          }
          ++i;
          _searchIndex = entries.indexWhere((element) =>
              element.name.isNotEmpty &&
              element.name[0] == String.fromCharCode(asciiLetter + i));
        }

        if (_searchIndex >= 0) {
          _itemScrollController.jumpTo(index: _searchIndex);
        } else {
          if (entries.isNotEmpty) {
            _searchIndex = entries.length - 1;
            _itemScrollController.jumpTo(index: _searchIndex);
          }
        }
      }
    });
  }

  /// Adds an entry with the given [name], [hint], and optional [identifier].
  void addEntry(String name, String hint, String identifier) {
    setState(() {
      controller.addEntry(entries, name, hint, identifier);
    });
  }

  /// Builds the home widget.
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: appbarColor,
              title: const Text('Passwd Hints'),
              actions: [
                IconButton(
                  onPressed: () {
                    showSearch(
                        context: context, delegate: AppSearchDelegate(entries));
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            body: Stack(
              children: [
                ScrollableList(
                    entries, _itemScrollController, _itemPositionsListener),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 10),
                  margin: const EdgeInsets.only(bottom: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: alphabets
                        .map((alphabet) => InkWell(
                              onTap: () {
                                setSearchIndex(alphabet);
                              },
                              child: Text(
                                alphabet,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                hintEntryAdditionButtonOnPress(context, this, entries);
              },
              shape: CircleBorder(),
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            ),
          );
  }
}