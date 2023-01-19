import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    required this.entries,
    required this.index,
  }) : super(key: key);

  final List entries;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                // handle overflow
                entries[index - 1].name,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              // put it better (its ugly and not interactive)
              child: Icon(Icons.remove_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}
