import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../domain/attachment.dart';
import 'attachment_picker.dart';
import 'attachment_viewer_screen.dart';
import 'expenses_providers.dart';

class AttachmentsSection extends ConsumerWidget {
  const AttachmentsSection(this.expenseId, {super.key});

  final int expenseId;

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final path = await pickReceiptImage(context);
    if (path == null) return;
    try {
      await ref.read(attachmentRepositoryProvider).add(expenseId, path);
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.actionFailed)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final attachments = ref.watch(attachmentsProvider(expenseId));
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
              onPressed: () => _add(context, ref),
              icon: const Icon(Icons.add_a_photo),
              label: Text(l10n.addAttachment),
            ),
          ],
        ),
        const SizedBox(height: 8),
        attachments.when(
          data: (items) => items.isEmpty
              ? Text(l10n.noAttachments)
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (int i = 0; i < items.length; i++)
                      _Thumbnail(
                        attachment: items[i],
                        attachments: items,
                        index: i,
                      )
                  ],
                ),
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) => Text(l10n.actionFailed),
        ),
      ],
    );
  }
}

class _Thumbnail extends ConsumerWidget {
  const _Thumbnail({
    required this.attachment,
    required this.attachments,
    required this.index,
  });

  final Attachment attachment;
  final List<Attachment> attachments;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => showAttachmentViewer(context, ref, attachments, index),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(attachment.path),
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
    );
  }
}
