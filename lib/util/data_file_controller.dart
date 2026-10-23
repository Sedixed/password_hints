import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:string_validator/string_validator.dart';

import '../constants.dart';
import 'hint_entry.dart';
import 'rsa_cipher.dart';

/// Result of an import or export operation.
enum FileOperationResult { success, cancelled, failed }

/// Handles data file reading and writing operations, using app entries.
class DataFileController {
  /// Local path to the file.
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Local file from the local path.
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$dataFileName');
  }

  /// Adds an entry to the [entries] list and then to the data file with the
  /// given parameters ([name], [hint], and optional [identifier]).
  Future<int> addEntry(
    List entries,
    String name,
    String hint,
    String identifier,
  ) async {
    final file = await _localFile;
    RSACipherizer cipher = RSACipherizer();

    HintEntry entry = HintEntry(name, cipher.cipherMessage(hint),
        identifier.isEmpty ? identifier : cipher.cipherMessage(identifier));
    entries.add(entry);
    entries.sort((a, b) => _compareEntries(a, b));

    entries.map((entry) => entry.toJson()).toList();
    // Write the file
    file.writeAsStringSync(json.encode(entries));

    return 1;
  }

  /// Removes the entry named [name] from data file. It browses the [entries]
  /// looking for one with this name, and if found it is removed.
  Future<int> removeEntry(List entries, String name) async {
    final file = await _localFile;

    entries.removeWhere((element) => element.name == name);
    entries.map((entry) => entry.toJson()).toList();
    // Write the file
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
        await file.create();
        print(file.path);
      }
      // Read the file
      final contents = await file.readAsString();
      if (contents.trim().isEmpty) {
        return 1;
      }
      var jsonResponse = jsonDecode(contents);

      entries.clear();
      if (jsonResponse is List) {
        for (var e in jsonResponse) {
          if (e is Map<String, dynamic>) {
            HintEntry entry = HintEntry.fromJson(e);
            if (entry.name.isNotEmpty) {
              entries.add(entry);
            }
          } else if (e is Map) {
            Map<String, dynamic> map = Map<String, dynamic>.from(e);
            HintEntry entry = HintEntry.fromJson(map);
            if (entry.name.isNotEmpty) {
              entries.add(entry);
            }
          }
        }
        entries.sort((a, b) => _compareEntries(a, b));
      }

      return 1;
    } catch (e) {
      print('Error reading entries: $e');
      return 0;
    }
  }

  /// Imports a file chosen by the user and overwrites the current data file.
  Future<FileOperationResult> importFile(List entries) async {
    try {
      PlatformFile? file = await FilePicker.pickFile();
      if (file == null || file.path == null) {
        return FileOperationResult.cancelled;
      }

      final importedFile = File(file.path!);
      final contents = await importedFile.readAsString();
      final jsonResponse = jsonDecode(contents);
      if (jsonResponse is! List) {
        return FileOperationResult.failed;
      }

      final localFile = await _localFile;
      await localFile.writeAsString(contents);

      entries.clear();
      for (var e in jsonResponse) {
        if (e is Map) {
          final map = Map<String, dynamic>.from(e);
          final entry = HintEntry.fromJson(map);
          if (entry.name.isNotEmpty) {
            entries.add(entry);
          }
        }
      }
      entries.sort((a, b) => _compareEntries(a, b));
      return FileOperationResult.success;
    } on Exception catch (error) {
      print('Error importing entries: $error');
      return FileOperationResult.failed;
    }
  }

  /// Exports the current data file to a user-selected destination.
  Future<FileOperationResult> exportFile() async {
    try {
      final localFile = await _localFile;
      if (!await localFile.exists()) {
        await localFile.create();
      }
      final bytes = await localFile.readAsBytes();

      Uri? result = await FilePicker.saveFile(
        fileName: dataFileName,
        bytes: bytes,
      );

      return result == null
          ? FileOperationResult.cancelled
          : FileOperationResult.success;
    } on Exception catch (error) {
      print('Error exporting entries: $error');
      return FileOperationResult.failed;
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
