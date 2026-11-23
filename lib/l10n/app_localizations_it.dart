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
  String get editExpenseTitle => 'Modifica Spesa';

  @override
  String get editTooltip => 'Modifica';

  @override
  String get deleteTooltip => 'Elimina';

  @override
  String get attachmentsTitle => 'Allegati';

  @override
  String get addAttachment => 'Aggiungi';

  @override
  String get noAttachments => 'Nessun allegato.';

  @override
  String get takePhoto => 'Scatta una foto';

  @override
  String get chooseFromGallery => 'Scegli dalla galleria';

  @override
  String get deleteAttachmentTitle => 'Eliminare l\'allegato?';

  @override
  String get deleteConfirmTitle => 'Eliminare la spesa?';

  @override
  String get deleteConfirmMessage => 'Questa azione non può essere annullata.';

  @override
  String get cancel => 'Annulla';

  @override
  String get expenseDeleted => 'Spesa eliminata';

  @override
  String get dateLabel => 'Data dell\'acquisto';

  @override
  String get amountLabel => 'Importo totale';

  @override
  String get categoryLabel => 'Categoria';

  @override
  String get merchantLabel => 'Esercente (facoltativo)';

  @override
  String get detailsTitle => 'Dettagli Spesa';

  @override
  String get merchantField => 'Esercente';

  @override
  String get notesField => 'Note';

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
