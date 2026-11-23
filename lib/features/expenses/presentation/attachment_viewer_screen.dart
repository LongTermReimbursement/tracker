import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/attachment.dart';
import 'expenses_providers.dart';

Future<void> showAttachmentViewer(
  BuildContext context,
  WidgetRef ref,
  List<Attachment> attachments,
  int initialIndex,
) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => _AttachmentViewerDialog(
      attachments: attachments,
      initialIndex: initialIndex,
      ref: ref,
    ),
  );
}

class _AttachmentViewerDialog extends ConsumerStatefulWidget {
  const _AttachmentViewerDialog({
    required this.attachments,
    required this.initialIndex,
    required this.ref,
  });

  final List<Attachment> attachments;
  final int initialIndex;
  final WidgetRef ref;

  @override
  ConsumerState<_AttachmentViewerDialog> createState() => _AttachmentViewerDialogState();
}

class _AttachmentViewerDialogState extends ConsumerState<_AttachmentViewerDialog> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final attachment = widget.attachments[_currentIndex];
    final isMultiple = widget.attachments.length > 1;

    return Dialog(
      insetPadding: const EdgeInsets.all(32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 500,
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ), 
              title: Text(l10n.attachmentsTitle),
              centerTitle: false,
              actions: [
                if (isMultiple)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: Text(
                        '${_currentIndex + 1}/${widget.attachments.length}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: l10n.deleteTooltip,
                  onPressed: () => _deleteAttachment(context, attachment, l10n),
                ),
              ],
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: widget.attachments.length,
                  itemBuilder: (ctx, index) => InteractiveViewer(
                    maxScale: 5,
                    minScale: 1,
                    child: Center(
                      child: Image.file(
                        File(widget.attachments[index].path),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 64),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (isMultiple)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _currentIndex > 0
                          ? () => _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              )
                          : null,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        widget.attachments.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentIndex
                                ? Theme.of(context).primaryColor
                                : Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: _currentIndex < widget.attachments.length - 1
                          ? () => _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              )
                          : null,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteAttachment(
    BuildContext context,
    Attachment attachment,
    AppLocalizations l10n,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

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
}
