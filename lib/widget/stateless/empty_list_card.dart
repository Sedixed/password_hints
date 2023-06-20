import 'package:flutter/material.dart';

/// Widget displayed when no entries are found in the application.
class EmptyListCard extends StatelessWidget {
  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Center(
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 40),
        child: Card(
          color: theme.colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text("Nothing here..yet !", style: style),
          ),
        ),
      ),
    );
  }
}
