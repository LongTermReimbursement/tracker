import 'package:material_ui/material_ui.dart';

import '../../features/expenses/domain/expense.dart';
import '../../l10n/app_localizations.dart';

// Not AppLocalizations.localizationsDelegates: it pulls in the legacy material delegate.
const appLocalizationsDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  ...GlobalMaterialLocalizations.delegates,
];

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension ExpenseCategoryLabel on AppLocalizations {
  String categoryLabelFor(ExpenseCategory category) => switch (category) {
    ExpenseCategory.meals => categoryMeals,
    ExpenseCategory.grocery => categoryGrocery,
  };
}
