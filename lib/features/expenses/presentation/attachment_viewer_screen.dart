import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../domain/attachment.dart';
import 'expenses_providers.dart';

class AttachmentViewerScreen extends ConsumerWidget {
  const AttachmentViewerScreen(this.attachment, {super.key});

  final Attachment attachment;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteAttachmentTitle),
        content: Text(l10n.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.deleteTooltip),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(attachmentRepositoryProvider).delete(attachment);
      navigator.pop();
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.actionFailed)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.attachmentsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: l10n.deleteTooltip,
            onPressed: () => _delete(context, ref),
          ),
        ],
      ),
      body: InteractiveViewer(
        maxScale: 5,
        child: Center(child: Image.file(File(attachment.path))),
      ),
    );
  }
}
