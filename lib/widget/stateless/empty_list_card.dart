import 'package:flutter/material.dart';

/// Widget displayed when no entries are found in the application.
class EmptyListCard extends StatelessWidget {
  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox.fromSize(
              size: Size.fromRadius(100),
              child: FittedBox(
                child: Icon(Icons.sentiment_very_dissatisfied),
              ),
            ),
            SizedBox.fromSize(
              size: Size.fromRadius(100),
              child: FittedBox(
                child: Text('Nothing.. yet !'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
