// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Reimbursements';

  @override
  String get expensesTitle => 'My Expenses';

  @override
  String get expensesEmpty => 'No expenses yet.\nTap + to add one!';

  @override
  String get expensesLoadError => 'Unable to load expenses.';

  @override
  String get addExpenseTitle => 'New Expense';

  @override
  String get editExpenseTitle => 'Edit Expense';

  @override
  String get editTooltip => 'Edit';

  @override
  String get deleteTooltip => 'Delete';

  @override
  String get attachmentsTitle => 'Attachments';

  @override
  String get addAttachment => 'Add';

  @override
  String get noAttachments => 'No attachments yet.';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get deleteAttachmentTitle => 'Delete attachment?';

  @override
  String get deleteConfirmTitle => 'Delete expense?';

  @override
  String get deleteConfirmMessage => 'This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get expenseDeleted => 'Expense deleted';

  @override
  String get dateLabel => 'Purchase date';

  @override
  String get amountLabel => 'Total amount';

  @override
  String get categoryLabel => 'Category';

  @override
  String get merchantLabel => 'Merchant (optional)';

  @override
  String get detailsTitle => 'Expense Details';

  @override
  String get merchantField => 'Merchant';

  @override
  String get notesField => 'Notes';

  @override
  String get notesLabel => 'Notes (optional)';

  @override
  String get categoryMeals => 'Meals';

  @override
  String get categoryGrocery => 'Grocery shop';

  @override
  String get save => 'Save';

  @override
  String get amountRequired => 'Enter the amount';

  @override
  String get amountInvalid => 'Invalid amount';

  @override
  String get expenseSaved => 'Expense saved';

  @override
  String get actionFailed => 'Something went wrong';
}
