import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/services/app_state.dart';
import 'core/services/local_key_value_store.dart';
import 'features/tasks/data/personal_task_repository.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state =
      AppState(LocalPersonalTaskRepository(SharedPreferencesStore.create()));
  await state.restore();
  runApp(TalibAlJamiaApp(state: state));
}

class TalibAlJamiaApp extends StatelessWidget {
  TalibAlJamiaApp({AppState? state, super.key})
      : state = state ??
            AppState(
                LocalPersonalTaskRepository(SharedPreferencesStore.create()));
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: state,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'طالب الجامعة',
        theme: AppTheme.light,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const HomeScreen(),
      ),
    );
  }
}
