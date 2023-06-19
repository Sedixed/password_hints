import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:string_validator/string_validator.dart';

import '../constants.dart';
import 'hint_entry.dart';

/// Handles data file reading and writing operations, using app entries.
class DataFileController {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$dataFileName');
  }

  /// Adds an entry to the [entries] list and then to the data file with the
  /// given parameters ([name], [hint], and optional [identifier]).
  Future<int> addEntry(
      List entries, String name, String hint, String identifier) async {
    final file = await _localFile;

    HintEntry entry = HintEntry(name, hint, identifier);
    entries.add(entry);
    entries.sort((a, b) => _compareEntries(a, b));

    entries
        .map(
          (entry) => entry.toJson(),
        )
        .toList();

    file.writeAsStringSync(json.encode(entries));
    // Write the file
    return 1;
  }

  /// Removes the entry named [name] from data file. It browses the [entries]
  /// looking for one with this name, and if found it is removed.
  Future<int> removeEntry(List entries, String name) async {
    final file = await _localFile;

    entries.removeWhere((element) => element.name == name);
    entries
        .map(
          (entry) => entry.toJson(),
        )
        .toList();

    file.writeAsStringSync(json.encode(entries));
    return 1;
  }

  /// Read entries from data file and writes them into the given [entries] list.
  /// This list is sorted before it is returned.
  Future<int> readEntries(List entries) async {
    try {
      final file = await _localFile;
      print(file.path);
      if (!await file.exists()) {
        file.create();
        print(file.path);
      }
      print('read');
      // Read the file
      final contents = await file.readAsString();
      var jsonResponse = jsonDecode(contents);

      entries.clear();
      for (var e in jsonResponse) {
        HintEntry entry = HintEntry(e['name'], e['hint'], e['identifier']);
        entries.add(entry);
      }
      entries.sort((a, b) => _compareEntries(a, b));

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  /// Compare two entries [a] and [b] to perform sorting operations on them.
  /// Alphabetical starting names are placed first, then numeric starting names,
  /// and finally special characters starting names.
  int _compareEntries(HintEntry a, HintEntry b) {
    String relevantA = a.name[0];
    String relevantB = b.name[0];

    if (isAlpha(relevantA)) {
      if (isAlpha(relevantB)) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }

      if (isNumeric(relevantB)) {
        return -1;
      }
      return 0;
    }
    if (isNumeric(relevantA)) {
      if (isAlpha(relevantB)) {
        return 1;
      }
      if (isNumeric(relevantB)) {
        return int.parse(relevantA).compareTo(int.parse(relevantB));
      }
      return -1;
    }
    if (isAlpha(relevantB) || isNumeric(relevantB)) {
      return -1;
    }
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  }
}
