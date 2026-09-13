import 'package:flutter/widgets.dart';

abstract final class AppStrings {
  static bool _isKurdish(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ku';

  static String text(BuildContext context, String key) {
    return (_isKurdish(context) ? _ku : _ar)[key] ?? key;
  }

  static const _ku = {
    'appTitle': 'My Task',
    'home': 'سەرەکی',
    'university': 'زانکۆ',
    'tasks': 'ئەرکەکان',
    'apartment': 'شوقە',
    'more': 'زیاتر',
    'add': 'زیادکردن',
    'personalTask': 'ئەرکی کەسی',
    'academicTask': 'ئەرکی زانکۆیی',
    'quizExam': 'Quiz یان تاقیکردنەوە',
    'note': 'تێبینی',
    'purchase': 'کڕین',
    'newPersonalTask': 'ئەرکی کەسیی نوێ',
    'writeTask': 'ئەرکەکە بنووسە',
    'cancel': 'هەڵوەشاندنەوە',
    'save': 'پاشەکەوت',
    'comingSoon': 'بەشی {section} بە زوویی لێرە بەردەست دەبێت.',
    'greeting': 'بەخێربێیت،',
    'organizeDay': 'ڕۆژەکەت بە ئارامی ڕێکبخە',
    'today': 'ئەمڕۆ',
    'noLectures': 'ئەمڕۆ وانە نییە',
    'addSubjectsSchedule':
        'بابەت و خشتەی خوێندنت زیاد بکە تا لێرە پیشان بدرێن.',
    'upcoming': 'لە ڕێگادا',
    'noUpcoming': 'هیچ بەروارێکی نزیک نییە',
    'addTaskForDeadline': 'ئەرک یان واجب زیاد بکە بۆ بەدواداچوونی بەروارەکەی.',
    'financialSnapshot': 'کورتەی دارایی',
    'myBalance': 'باڵانسی من',
    'apartmentBalance': 'باڵانسی شوقە',
    'addSubject': 'بابەت زیاد بکە',
    'noSubjects':
        'هێشتا هیچ بابەتێک نییە\nیەکەم بابەت و خشتەی خوێندنی زیاد بکە.',
    'universitySubject': 'بابەتی زانکۆیی',
    'newSubject': 'بابەتی نوێ',
    'subjectName': 'ناوی بابەت',
    'codeOptional': 'کۆد (ئارەزوومەندانە)',
    'noTasks':
        'هێشتا هیچ ئەرکێک نییە\nدوگمەی زیادکردن دابگرە بۆ دروستکردنی یەکەم ئەرک.',
    'language': 'زمان',
    'kurdish': 'کوردی (سۆرانی)',
    'arabic': 'عەرەبی',
    'languageDescription': 'زمانی پێشکەوتە: کوردی',
  };

  static const _ar = {
    'appTitle': 'My Task',
    'home': 'الرئيسية',
    'university': 'الجامعة',
    'tasks': 'المهام',
    'apartment': 'الشقة',
    'more': 'المزيد',
    'add': 'إضافة',
    'personalTask': 'مهمة شخصية',
    'academicTask': 'واجب جامعي',
    'quizExam': 'Quiz أو امتحان',
    'note': 'ملاحظة',
    'purchase': 'عملية شراء',
    'newPersonalTask': 'مهمة شخصية جديدة',
    'writeTask': 'اكتب المهمة',
    'cancel': 'إلغاء',
    'save': 'حفظ',
    'comingSoon': 'ستظهر هنا وحدة {section} في المرحلة التالية.',
    'greeting': 'مرحباً،',
    'organizeDay': 'رتّب يومك بهدوء',
    'today': 'اليوم',
    'noLectures': 'لا توجد محاضرات اليوم',
    'addSubjectsSchedule': 'أضف موادك وجدولك الدراسي لتظهر هنا.',
    'upcoming': 'القادم',
    'noUpcoming': 'لا توجد مواعيد قريبة',
    'addTaskForDeadline': 'أضف واجباً أو مهمة حتى تتابع موعدها بسهولة.',
    'financialSnapshot': 'لمحة مالية',
    'myBalance': 'رصيدي',
    'apartmentBalance': 'رصيد الشقة',
    'addSubject': 'إضافة مادة',
    'noSubjects': 'لا توجد مواد حالياً\nأضف أول مادة وجدولها الدراسي.',
    'universitySubject': 'مادة جامعية',
    'newSubject': 'مادة جديدة',
    'subjectName': 'اسم المادة',
    'codeOptional': 'الرمز (اختياري)',
    'noTasks': 'لا توجد مهام حالياً\nاضغط إضافة لإنشاء أول مهمة.',
    'language': 'اللغة',
    'kurdish': 'الكردية (سوراني)',
    'arabic': 'العربية',
    'languageDescription': 'اللغة الأساسية: الكردية',
  };
}
