class Attachment {
  const Attachment({
    required this.id,
    required this.expenseId,
    required this.path,
  });

  final int id;
  final int expenseId;

  /// Absolute path of the image file on the device.
  final String path;
}
