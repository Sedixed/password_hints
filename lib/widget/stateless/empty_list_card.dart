import 'package:flutter/material.dart';

/// Widget displayed when no entries are found in the application.
class EmptyListCard extends StatelessWidget {
  const EmptyListCard({required this.onAddHint, super.key});

  final VoidCallback onAddHint;

  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.key_outlined,
                  size: 34,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No hints yet',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Add a hint to keep a helpful reminder with your account.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onAddHint,
                icon: const Icon(Icons.add),
                label: const Text('Add your first hint'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
