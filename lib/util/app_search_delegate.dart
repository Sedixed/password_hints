import 'package:flutter/material.dart';
import 'package:passwd_hints/widget/stateful/state/home_state.dart';

import 'buttons_actions.dart';
import 'hint_entry.dart';

/// Handles the entry search.
class AppSearchDelegate extends SearchDelegate {
  /// The entries list
  final List<HintEntry> _entries;

  /// The build context of the app home.
  final BuildContext _baseContext;

  /// The home state.
  final HomeState _homeState;

  /// Default constructor.
  AppSearchDelegate(this._entries, this._baseContext, this._homeState);

  /// Builds the search actions (close or clear).
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
          icon: const Icon(Icons.clear),
        ),
      ];

  /// Builds the closing icon and its actions.
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back));

  /// Builds the result : not used so we just return an empty container.
  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  /// Builds the suggestions from what has been typed.
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

  /// Show the results inside an alert dialog.
  @override
  void showResults(context) {
    Navigator.pop(context);

    hintEntryDisplayButtonOnPress(
      _baseContext,
      _entries,
      _entries.firstWhere((element) => element.name == query),
      _homeState,
    );
  }
}
