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
import '../../stateless/alphabet_index.dart';

/// HomeState widget : defines the state of the app.
class HomeState extends State<Home> {
  // Alphabet
  final _alphabets = List.generate(
    26,
    (index) => String.fromCharCode(index + firstLetterIndex),
  );

  // Search index (right panel)
  int _searchIndex = 0;
  String? _selectedLetter;

  // Hint entries
  List<HintEntry> _entries = [];

  // Scroll controllers / jumpers
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  // File controller
  final DataFileController _controller = DataFileController();

  // Loading toggle
  bool _isLoading = true;

  /// Initializes the home state by reading the data file and adding the missing
  /// alphabet elements (0 for numeric and # for special characters).
  @override
  void initState() {
    super.initState();
    _alphabets.add('0');
    _alphabets.add('#');
    readEntries();
  }

  /// Sets the search index after a tap on searchLetter on the screen.
  /// If a matching entry is directly found, jumps to it. Otherwise, it
  /// reads the next entries and jumps to the first found. If there is no entry
  /// after the searched one, no jump is performed.
  void setSearchIndex(String searchLetter) {
    if (_entries.isEmpty) {
      return;
    }

    setState(() {
      _selectedLetter = searchLetter;
      _searchIndex = _entries.indexWhere((element) =>
          element.name.isNotEmpty &&
          (element.name[0].toUpperCase() == searchLetter ||
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
          if (i + asciiLetter > firstLetterIndex + zIndex + 1) {
            break;
          }
          ++i;
          _searchIndex = _entries.indexWhere((element) =>
              element.name.isNotEmpty &&
              element.name[0] == String.fromCharCode(asciiLetter + i));
        }

        if (_searchIndex >= 0) {
          _itemScrollController.jumpTo(index: _searchIndex);
        } else {
          if (_entries.isNotEmpty) {
            _searchIndex = _entries.length - 1;
            _itemScrollController.jumpTo(index: _searchIndex);
          }
        }
      }
    });
  }

  /// Adds an entry with the given [name], [hint], and optional [identifier].
  Future<void> addEntry(String name, String hint, String identifier) async {
    await _controller.addEntry(_entries, name, hint, identifier);
    if (mounted) {
      setState(() {});
    }
  }

  /// Reads the entries from the data file.
  Future<void> readEntries() async {
    final result = await _controller.readEntries(_entries);
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = false;
    });
    if (result == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to load your hints.')),
      );
    }
  }

  /// Imports the data file, overwrites current entries, and shows a SnackBar.
  void importEntries() async {
    final result = await _controller.importFile(_entries);
    if (!mounted || result == FileOperationResult.cancelled) {
      return;
    }
    if (result == FileOperationResult.success) {
      setState(() {});
    }
    final message = result == FileOperationResult.success
        ? 'File imported successfully'
        : 'Unable to import this file.';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  /// Exports the current data file and shows a SnackBar.
  void exportEntries() async {
    final result = await _controller.exportFile();
    if (!mounted || result == FileOperationResult.cancelled) {
      return;
    }
    final message = result == FileOperationResult.success
        ? 'File exported successfully'
        : 'Unable to export your hints.';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  /// Builds the home widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passwd Hints'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: AppSearchDelegate(_entries, context, this),
              );
            },
            icon: const Icon(Icons.search),
            tooltip: 'Search hints',
          ),
          PopupMenuButton<String>(
            tooltip: 'More options',
            onSelected: (value) {
              if (value == 'import') {
                importEntries();
              } else {
                exportEntries();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(Icons.file_upload_outlined),
                    SizedBox(width: 12),
                    Text('Import file'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.file_download_outlined),
                    SizedBox(width: 12),
                    Text('Export file'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Expanded(
                  child: ScrollableList(
                    _entries,
                    _itemScrollController,
                    _itemPositionsListener,
                    this,
                  ),
                ),
                if (_entries.isNotEmpty)
                  AlphabetIndex(
                    alphabets: _alphabets,
                    selectedLetter: _selectedLetter,
                    onSelected: setSearchIndex,
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => hintEntryAdditionButtonOnPress(
          context,
          this,
          _entries,
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add hint'),
      ),
    );
  }
}
