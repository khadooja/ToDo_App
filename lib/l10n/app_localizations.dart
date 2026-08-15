import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// Home page app bar title
  ///
  /// In en, this message translates to:
  /// **'My Tasks'**
  String get myTasks;

  /// Add task button / page title
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTask;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTask;

  /// No description provided for @noTasksYetTitle.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any tasks yet!'**
  String get noTasksYetTitle;

  /// No description provided for @noTasksYetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap on the + button to add a new task'**
  String get noTasksYetSubtitle;

  /// No description provided for @noTasksForDateTitle.
  ///
  /// In en, this message translates to:
  /// **'No tasks for this date.'**
  String get noTasksForDateTitle;

  /// No description provided for @noTasksForDateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try another day or add a new task'**
  String get noTasksForDateSubtitle;

  /// No description provided for @deleteAllTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete All Tasks'**
  String get deleteAllTasksTitle;

  /// No description provided for @deleteAllTasksConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all tasks?'**
  String get deleteAllTasksConfirm;

  /// No description provided for @deleteTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get deleteTaskTitle;

  /// No description provided for @deleteTaskConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this task?'**
  String get deleteTaskConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @titleField.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleField;

  /// No description provided for @noteField.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteField;

  /// No description provided for @dateField.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateField;

  /// No description provided for @startTimeField.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTimeField;

  /// No description provided for @endTimeField.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTimeField;

  /// No description provided for @remindField.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get remindField;

  /// No description provided for @repeatField.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeatField;

  /// No description provided for @colorField.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorField;

  /// No description provided for @createTaskButton.
  ///
  /// In en, this message translates to:
  /// **'Create Task'**
  String get createTaskButton;

  /// No description provided for @updateTaskButton.
  ///
  /// In en, this message translates to:
  /// **'Update Task'**
  String get updateTaskButton;

  /// No description provided for @requiredFieldsTitle.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredFieldsTitle;

  /// No description provided for @requiredFieldsMessage.
  ///
  /// In en, this message translates to:
  /// **'All fields are required!'**
  String get requiredFieldsMessage;

  /// No description provided for @taskUpdatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Updated'**
  String get taskUpdatedTitle;

  /// No description provided for @taskUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'The task has been successfully updated!'**
  String get taskUpdatedMessage;

  /// No description provided for @darkModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkModeLabel;

  /// No description provided for @notificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsLabel;

  /// No description provided for @todoOptionsHeader.
  ///
  /// In en, this message translates to:
  /// **'Todo Options'**
  String get todoOptionsHeader;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @sectionMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get sectionMorning;

  /// No description provided for @sectionAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get sectionAfternoon;

  /// No description provided for @sectionEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get sectionEvening;

  /// Task count badge for the selected date
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No tasks} =1{1 task} other{{count} tasks}}'**
  String taskCountLabel(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
