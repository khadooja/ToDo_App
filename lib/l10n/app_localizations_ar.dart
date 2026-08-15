// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get myTasks => 'مهامي';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get noTasksYetTitle => 'لا توجد لديك أي مهام بعد!';

  @override
  String get noTasksYetSubtitle => 'اضغط على زر + لإضافة مهمة جديدة';

  @override
  String get noTasksForDateTitle => 'لا توجد مهام في هذا التاريخ.';

  @override
  String get noTasksForDateSubtitle => 'جرّب يومًا آخر أو أضف مهمة جديدة';

  @override
  String get deleteAllTasksTitle => 'حذف جميع المهام';

  @override
  String get deleteAllTasksConfirm => 'هل أنت متأكد أنك تريد حذف جميع المهام؟';

  @override
  String get deleteTaskTitle => 'حذف المهمة';

  @override
  String get deleteTaskConfirm => 'هل أنت متأكد أنك تريد حذف هذه المهمة؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get close => 'إغلاق';

  @override
  String get titleField => 'العنوان';

  @override
  String get noteField => 'ملاحظة';

  @override
  String get dateField => 'التاريخ';

  @override
  String get startTimeField => 'وقت البدء';

  @override
  String get endTimeField => 'وقت الانتهاء';

  @override
  String get remindField => 'تذكير';

  @override
  String get repeatField => 'التكرار';

  @override
  String get colorField => 'اللون';

  @override
  String get createTaskButton => 'إنشاء مهمة';

  @override
  String get updateTaskButton => 'تحديث المهمة';

  @override
  String get requiredFieldsTitle => 'مطلوب';

  @override
  String get requiredFieldsMessage => 'جميع الحقول مطلوبة!';

  @override
  String get taskUpdatedTitle => 'تم تحديث المهمة';

  @override
  String get taskUpdatedMessage => 'تم تحديث المهمة بنجاح!';

  @override
  String get darkModeLabel => 'الوضع الداكن';

  @override
  String get notificationsLabel => 'الإشعارات';

  @override
  String get todoOptionsHeader => 'خيارات المهام';

  @override
  String get greetingMorning => 'صباح الخير';

  @override
  String get greetingAfternoon => 'مساء الخير';

  @override
  String get greetingEvening => 'مساء الخير';

  @override
  String get sectionMorning => 'الصباح';

  @override
  String get sectionAfternoon => 'بعد الظهر';

  @override
  String get sectionEvening => 'المساء';

  @override
  String taskCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مهام',
      one: 'مهمة واحدة',
      zero: 'لا توجد مهام',
    );
    return '$_temp0';
  }
}
