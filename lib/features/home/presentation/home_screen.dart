import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/services/app_state.dart';
import '../../../core/services/language_controller.dart';
import '../../../features/tasks/domain/personal_task.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/section_header.dart';

String s(BuildContext context, String key) => AppStrings.text(context, key);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _tabKeys = ['home', 'university', 'tasks', 'apartment', 'more'];
  static const _icons = [
    Icons.home_outlined,
    Icons.school_outlined,
    Icons.task_alt_outlined,
    Icons.apartment_outlined,
    Icons.grid_view_rounded
  ];

  @override
  Widget build(BuildContext context) {
    final selected = context.watch<AppState>().selectedTab;
    return Scaffold(
      appBar: AppBar(title: Text(s(context, _tabKeys[selected]))),
      body: SafeArea(child: _TabContent(index: selected)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuickAdd(context),
        icon: const Icon(Icons.add),
        label: Text(s(context, 'add')),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: context.read<AppState>().selectTab,
        destinations: List.generate(
            _tabKeys.length,
            (index) => NavigationDestination(
                icon: Icon(_icons[index]), label: s(context, _tabKeys[index]))),
      ),
    );
  }

  void _showQuickAdd(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (sheetContext) => SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(runSpacing: 8, children: [
                ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: Text(s(context, 'personalTask')),
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) _showTaskForm(context);
                      });
                    }),
                ListTile(
                    leading: const Icon(Icons.assignment_outlined),
                    title: Text(s(context, 'academicTask')),
                    onTap: () => _openTaskForm(context, sheetContext,
                        formTitle: s(context, 'academicTask'))),
                ListTile(
                    leading: const Icon(Icons.quiz_outlined),
                    title: Text(s(context, 'quizExam')),
                    onTap: () => _openTaskForm(context, sheetContext,
                        formTitle: s(context, 'quizExam'))),
                ListTile(
                    leading: const Icon(Icons.note_add_outlined),
                    title: Text(s(context, 'note')),
                    onTap: () => _openTaskForm(context, sheetContext,
                        formTitle: s(context, 'note'))),
                ListTile(
                    leading: const Icon(Icons.shopping_basket_outlined),
                    title: Text(s(context, 'purchase')),
                    onTap: () => _openTaskForm(context, sheetContext,
                        formTitle: s(context, 'purchase'),
                        category: PersonalTaskCategory.shopping)),
              ]),
            )));
  }

  void _openTaskForm(BuildContext context, BuildContext sheetContext,
      {required String formTitle,
      PersonalTaskCategory category = PersonalTaskCategory.other}) {
    Navigator.of(sheetContext).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        _showTaskForm(context, formTitle: formTitle, category: category);
      }
    });
  }

  void _showTaskForm(BuildContext context,
      {String? formTitle,
      PersonalTaskCategory category = PersonalTaskCategory.personal}) {
    var taskTitle = '';
    showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
              title: Text(formTitle ?? s(context, 'newPersonalTask')),
              content: TextField(
                  autofocus: true,
                  onChanged: (value) => taskTitle = value,
                  decoration:
                      InputDecoration(hintText: s(context, 'writeTask'))),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(s(context, 'cancel'))),
                FilledButton(
                    onPressed: () async {
                      if (taskTitle.trim().isEmpty) return;
                      await context
                          .read<AppState>()
                          .addTask(taskTitle, category: category);
                      if (dialogContext.mounted) Navigator.pop(dialogContext);
                    },
                    child: Text(s(context, 'save'))),
              ],
            ));
  }

}

class _TabContent extends StatelessWidget {
  const _TabContent({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    if (index == 1) return const _AcademicTab();
    if (index == 2) return const _TasksTab();
    if (index == 4) return const _MoreTab();
    if (index != 0) {
      return Center(
          child: Text(s(context, 'comingSoon').replaceFirst(
              '{section}', s(context, HomeScreen._tabKeys[index]))));
    }
    return ListView(padding: const EdgeInsets.all(20), children: [
      Text(s(context, 'greeting'), style: const TextStyle(fontSize: 16)),
      const SizedBox(height: 4),
      Text(s(context, 'organizeDay'),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
      const SizedBox(height: 24),
      SectionHeader(title: s(context, 'today')),
      const SizedBox(height: 8),
      AppCard(
          child: ListTile(
              leading: const Icon(Icons.school_outlined),
              title: Text(s(context, 'noLectures')),
              subtitle: Text(s(context, 'addSubjectsSchedule')),
              onTap: () => context.read<AppState>().selectTab(1))),
      const SizedBox(height: 20),
      SectionHeader(title: s(context, 'upcoming')),
      const SizedBox(height: 8),
      AppCard(
          child: ListTile(
              leading: const Icon(Icons.event_note_outlined),
              title: Text(s(context, 'noUpcoming')),
              subtitle: Text(s(context, 'addTaskForDeadline')),
              onTap: () => context.read<AppState>().selectTab(2))),
      const SizedBox(height: 20),
      SectionHeader(title: s(context, 'financialSnapshot')),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(
            child: _Balance(label: s(context, 'myBalance'), value: '٠ د.ع')),
        const SizedBox(width: 12),
        Expanded(
            child: _Balance(
                label: s(context, 'apartmentBalance'), value: '٠ د.ع')),
      ]),
    ]);
  }
}

class _AcademicTab extends StatelessWidget {
  const _AcademicTab();
  @override
  Widget build(BuildContext context) {
    final subjects = context.watch<AppState>().subjects;
    return ListView(padding: const EdgeInsets.all(20), children: [
      FilledButton.icon(
          onPressed: () => _addSubject(context),
          icon: const Icon(Icons.add),
          label: Text(s(context, 'addSubject'))),
      const SizedBox(height: 16),
      if (subjects.isEmpty)
        Center(
            child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(s(context, 'noSubjects'),
                    textAlign: TextAlign.center)))
      else
        ...subjects.map((subject) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AppCard(
                child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Color(subject.colorValue)),
                    title: Text(subject.name),
                    subtitle: Text(
                        subject.code ?? s(context, 'universitySubject')))))),
    ]);
  }

  void _addSubject(BuildContext context) {
    var name = '';
    var code = '';
    showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
              title: Text(s(context, 'newSubject')),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                    autofocus: true,
                    decoration:
                        InputDecoration(labelText: s(context, 'subjectName')),
                    onChanged: (value) => name = value),
                const SizedBox(height: 12),
                TextField(
                    decoration:
                        InputDecoration(labelText: s(context, 'codeOptional')),
                    onChanged: (value) => code = value),
              ]),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(s(context, 'cancel'))),
                FilledButton(
                    onPressed: () async {
                      if (name.trim().isEmpty) return;
                      await context
                          .read<AppState>()
                          .addSubject(name, code: code);
                      if (dialogContext.mounted) Navigator.pop(dialogContext);
                    },
                    child: Text(s(context, 'save'))),
              ],
            ));
  }
}

class _TasksTab extends StatelessWidget {
  const _TasksTab();
  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<AppState>().tasks;
    if (tasks.isEmpty) {
      return Center(
          child: Text(s(context, 'noTasks'), textAlign: TextAlign.center));
    }
    return ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: tasks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, index) => AppCard(
            child: ListTile(
                leading: const Icon(Icons.radio_button_unchecked),
                title: Text(tasks[index].title),
                subtitle: Text(s(context, 'personalTask')))));
  }
}

class _MoreTab extends StatelessWidget {
  const _MoreTab();

  static final Uri _androidDownloadUrl = Uri.parse(
      'https://github.com/NashatShamsadyn7/My-Task/releases/latest');

  Future<void> _openAndroidDownload(BuildContext context) async {
    final opened = await launchUrl(_androidDownloadUrl,
        mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Could not open the Android download page.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageController>();
    return ListView(padding: const EdgeInsets.all(20), children: [
      const SectionHeader(title: 'Android'),
      const SizedBox(height: 8),
      AppCard(
          child: ListTile(
              leading: const Icon(Icons.android_rounded),
              title: const Text('Download My Task APK'),
              subtitle: const Text('Get the latest Android version from GitHub'),
              trailing: const Icon(Icons.open_in_new_rounded),
              onTap: () => _openAndroidDownload(context))),
      const SizedBox(height: 20),
      SectionHeader(title: s(context, 'language')),
      const SizedBox(height: 8),
      AppCard(
          child: Column(children: [
        ListTile(
            leading: Icon(language.locale.languageCode == 'ku'
                ? Icons.radio_button_checked
                : Icons.radio_button_off),
            onTap: () => language.changeLanguage('ku'),
            title: Text(s(context, 'kurdish')),
            subtitle: Text(s(context, 'languageDescription'))),
        ListTile(
            leading: Icon(language.locale.languageCode == 'ar'
                ? Icons.radio_button_checked
                : Icons.radio_button_off),
            onTap: () => language.changeLanguage('ar'),
            title: Text(s(context, 'arabic'))),
      ])),
    ]);
  }
}

class _Balance extends StatelessWidget {
  const _Balance({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => AppCard(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.titleMedium)
      ]));
}
