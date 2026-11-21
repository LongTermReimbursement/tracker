// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Rimborsi';

  @override
  String get expensesTitle => 'Le Mie Spese';

  @override
  String get expensesEmpty =>
      'Nessuna spesa registrata.\nTocca + per aggiungerne una!';

  @override
  String get expensesLoadError => 'Impossibile caricare le spese.';

  @override
  String get addExpenseTitle => 'Nuova Spesa';

  @override
  String get dateLabel => 'Data dell\'acquisto';

  @override
  String get amountLabel => 'Importo totale';

  @override
  String get categoryLabel => 'Categoria';

  @override
  String get notesLabel => 'Note (facoltative)';

  @override
  String get categoryMeals => 'Pasti';

  @override
  String get categoryGrocery => 'Spesa';

  @override
  String get save => 'Salva';

  @override
  String get amountRequired => 'Inserisci l\'importo';

  @override
  String get amountInvalid => 'Importo non valido';

  @override
  String get expenseSaved => 'Spesa salvata';

  @override
  String get actionFailed => 'Qualcosa è andato storto';
}
