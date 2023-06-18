import 'package:flutter/material.dart';

import 'hint_entry.dart';

class AppSearchDelegate extends SearchDelegate {
  final List<HintEntry> _entries;

  AppSearchDelegate(this._entries);

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear)),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) => Center(
      child: Text(query,
          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold)));

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> entriesNames = [];
    for (var he in _entries) {
      entriesNames.add(he.name);
    }

    List<String> suggestions = entriesNames.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}
