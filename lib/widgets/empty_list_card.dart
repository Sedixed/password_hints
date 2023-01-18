import 'package:flutter/material.dart';

class EmptyListCard extends StatelessWidget {
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
              child: Text("Nothing here..yet !", style: style)),
        ),
      ),
    );
  }
}
