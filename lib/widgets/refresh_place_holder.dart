import 'package:flutter/material.dart';

class RefreshPlaceholder extends StatelessWidget {
  final void Function()? onRefresh;
  final String message;

  const RefreshPlaceholder({super.key, required this.message, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 256,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SelectableText(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
            ),
            const SizedBox(height: 8),
            onRefresh != null
                ? ActionChip(
              visualDensity: VisualDensity.compact,
              avatar: const Icon(Icons.refresh_outlined),
              label: const Text('点击刷新'),
              onPressed: onRefresh,
            )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

}