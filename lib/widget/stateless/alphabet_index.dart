import 'package:flutter/material.dart';

/// Compact, non-scrolling alphabet index for jumping through the entry list.
class AlphabetIndex extends StatelessWidget {
  const AlphabetIndex({
    required this.alphabets,
    required this.selectedLetter,
    required this.onSelected,
    super.key,
  });

  final List<String> alphabets;
  final String? selectedLetter;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(context).textTheme.labelSmall;
    final textDirection = Directionality.of(context);
    final textScaler = MediaQuery.textScalerOf(context);
    var labelWidth = 0.0;
    for (final alphabet in alphabets) {
      for (final fontWeight in [FontWeight.normal, FontWeight.bold]) {
        final painter = TextPainter(
          text: TextSpan(
            text: alphabet,
            style: labelStyle?.copyWith(fontWeight: fontWeight),
          ),
          textDirection: textDirection,
          textScaler: textScaler,
        )..layout();
        if (painter.width > labelWidth) {
          labelWidth = painter.width;
        }
      }
    }

    return Material(
      color: colorScheme.surfaceContainer,
      child: SizedBox(
        width: labelWidth + 20,
        child: LayoutBuilder(
          builder: (context, constraints) {
            const reservedBottomHeight = 96.0;
            final gridHeight =
                (constraints.maxHeight - reservedBottomHeight).clamp(
              0.0,
              constraints.maxHeight,
            );
            final rowHeight = gridHeight / alphabets.length;

            return Column(
              children: [
                SizedBox(
                  height: gridHeight,
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: alphabets.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisExtent: rowHeight,
                    ),
                    itemBuilder: (context, index) {
                      final alphabet = alphabets[index];
                      final selected = selectedLetter == alphabet;
                      return Semantics(
                        button: true,
                        label: 'Jump to $alphabet',
                        child: InkWell(
                          onTap: () => onSelected(alphabet),
                          child: Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? colorScheme.primaryContainer
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                alphabet,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: selected
                                          ? colorScheme.onPrimaryContainer
                                          : colorScheme.onSurfaceVariant,
                                      fontWeight: selected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: reservedBottomHeight),
              ],
            );
          },
        ),
      ),
    );
  }
}
