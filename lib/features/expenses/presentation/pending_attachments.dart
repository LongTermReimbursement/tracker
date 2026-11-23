import 'dart:io';

import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import 'attachment_picker.dart';

/// Attachments chosen while creating an expense, not stored yet.
class PendingAttachments extends StatelessWidget {
  const PendingAttachments({
    super.key,
    required this.paths,
    required this.onChanged,
  });

  final List<String> paths;
  final ValueChanged<List<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.attachmentsTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                final path = await pickReceiptImage(context);
                if (path != null) onChanged([...paths, path]);
              },
              icon: const Icon(Icons.add_a_photo),
              label: Text(l10n.addAttachment),
            ),
          ],
        ),
        if (paths.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final path in paths)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(path),
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                        cacheWidth: 192,
                        errorBuilder: (context, error, stackTrace) => const SizedBox(
                          width: 96,
                          height: 96,
                          child: Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton.filledTonal(
                        iconSize: 16,
                        visualDensity: VisualDensity.compact,
                        tooltip: l10n.deleteTooltip,
                        icon: const Icon(Icons.close),
                        onPressed: () => onChanged([...paths]..remove(path)),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ],
    );
  }
}
