import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/services/app_state.dart';
import 'core/services/language_controller.dart';
import 'core/services/local_key_value_store.dart';
import 'features/tasks/data/personal_task_repository.dart';
import 'features/academic/data/subject_repository.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = SharedPreferencesStore.create();
  final state = AppState(LocalPersonalTaskRepository(store),
      subjectRepository: LocalSubjectRepository(store));
  await state.restore();
  final language = await LanguageController.create();
  runApp(TalibAlJamiaApp(state: state, language: language));
}

class TalibAlJamiaApp extends StatelessWidget {
  TalibAlJamiaApp({AppState? state, LanguageController? language, super.key})
      : state = state ??
            AppState(
                LocalPersonalTaskRepository(SharedPreferencesStore.create())),
        language = language ?? LanguageController();
  final AppState state;
  final LanguageController language;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: state),
        ChangeNotifierProvider.value(value: language),
      ],
      child: Consumer<LanguageController>(
        builder: (context, language, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My Task',
          theme: AppTheme.light,
          locale: language.locale,
          supportedLocales: const [Locale('ku'), Locale('ar')],
          localizationsDelegates: const [
            _KurdishMaterialLocalizationsDelegate(),
            _KurdishWidgetsLocalizationsDelegate(),
            _KurdishCupertinoLocalizationsDelegate(),
          ],
          builder: (context, child) => Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}

class _KurdishMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _KurdishMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'ku' || locale.languageCode == 'ar';

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      GlobalMaterialLocalizations.delegate.load(_fallbackLocale(locale));

  @override
  bool shouldReload(_KurdishMaterialLocalizationsDelegate old) => false;
}

class _KurdishWidgetsLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const _KurdishWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'ku' || locale.languageCode == 'ar';

  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      GlobalWidgetsLocalizations.delegate.load(_fallbackLocale(locale));

  @override
  bool shouldReload(_KurdishWidgetsLocalizationsDelegate old) => false;
}

class _KurdishCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _KurdishCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'ku' || locale.languageCode == 'ar';

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      GlobalCupertinoLocalizations.delegate.load(_fallbackLocale(locale));

  @override
  bool shouldReload(_KurdishCupertinoLocalizationsDelegate old) => false;
}

Locale _fallbackLocale(Locale locale) =>
    locale.languageCode == 'ku' ? const Locale('ar') : locale;
