import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/app_state.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _tabs = ['الرئيسية', 'الجامعة', 'المهام', 'الشقة', 'المزيد'];
  static const _icons = [
    Icons.home_outlined,
    Icons.school_outlined,
    Icons.task_alt_outlined,
    Icons.apartment_outlined,
    Icons.grid_view_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final selected = context.watch<AppState>().selectedTab;
    return Scaffold(
      appBar: AppBar(title: Text(_tabs[selected])),
      body: SafeArea(child: _TabContent(index: selected)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuickAdd(context),
        icon: const Icon(Icons.add),
        label: const Text('إضافة'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: context.read<AppState>().selectTab,
        destinations: List.generate(
          _tabs.length,
          (index) => NavigationDestination(
              icon: Icon(_icons[index]), label: _tabs[index]),
        ),
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
          child: Wrap(
            runSpacing: 8,
            children: [
              ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: const Text('مهمة شخصية'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) _showTaskForm(context);
                    });
                  }),
              const ListTile(
                  leading: Icon(Icons.assignment_outlined),
                  title: Text('واجب جامعي')),
              const ListTile(
                  leading: Icon(Icons.quiz_outlined),
                  title: Text('Quiz أو امتحان')),
              const ListTile(
                  leading: Icon(Icons.note_add_outlined),
                  title: Text('ملاحظة')),
              const ListTile(
                  leading: Icon(Icons.shopping_basket_outlined),
                  title: Text('عملية شراء')),
            ],
          ),
        ),
      ),
    );
  }

  void _showTaskForm(BuildContext context) {
    var title = '';
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('مهمة شخصية جديدة'),
        content: TextField(
            autofocus: true,
            onChanged: (value) => title = value,
            decoration: const InputDecoration(hintText: 'اكتب المهمة')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء')),
          FilledButton(
              onPressed: () async {
                if (title.trim().isEmpty) return;
                await context.read<AppState>().addTask(title);
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: const Text('حفظ')),
        ],
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    if (index == 1) return const _AcademicTab();
    if (index == 2) return const _TasksTab();
    if (index != 0) {
      return Center(
          child: Text(
              'ستظهر هنا وحدة ${HomeScreen._tabs[index]} في المرحلة التالية.'));
    }
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        Text('مرحباً،', style: TextStyle(fontSize: 16)),
        SizedBox(height: 4),
        Text('رتّب يومك بهدوء',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
        SizedBox(height: 24),
        SectionHeader(title: 'اليوم'),
        SizedBox(height: 8),
        AppCard(
            child: ListTile(
                leading: Icon(Icons.school_outlined),
                title: Text('لا توجد محاضرات اليوم'),
                subtitle: Text('أضف موادك وجدولك الدراسي لتظهر هنا.'))),
        SizedBox(height: 20),
        SectionHeader(title: 'القادم'),
        SizedBox(height: 8),
        AppCard(
            child: ListTile(
                leading: Icon(Icons.event_note_outlined),
                title: Text('لا توجد مواعيد قريبة'),
                subtitle: Text('أضف واجباً أو مهمة حتى تتابع موعدها بسهولة.'))),
        SizedBox(height: 20),
        SectionHeader(title: 'لمحة مالية'),
        SizedBox(height: 8),
        Row(children: [
          Expanded(child: _Balance(label: 'رصيدي', value: '٠ د.ع')),
          SizedBox(width: 12),
          Expanded(child: _Balance(label: 'رصيد الشقة', value: '٠ د.ع'))
        ]),
      ],
    );
  }
}

class _AcademicTab extends StatelessWidget {
  const _AcademicTab();
  @override
  Widget build(BuildContext context) {
    final subjects = context.watch<AppState>().subjects;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        FilledButton.icon(
            onPressed: () => _addSubject(context),
            icon: const Icon(Icons.add),
            label: const Text('إضافة مادة')),
        const SizedBox(height: 16),
        if (subjects.isEmpty)
          const Center(
              child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                      'لا توجد مواد حالياً\nأضف أول مادة وجدولها الدراسي.',
                      textAlign: TextAlign.center)))
        else
          ...subjects.map((subject) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppCard(
                  child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Color(subject.colorValue)),
                      title: Text(subject.name),
                      subtitle: Text(subject.code ?? 'مادة جامعية'))))),
      ],
    );
  }

  void _addSubject(BuildContext context) {
    var name = '';
    var code = '';
    showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
              title: const Text('مادة جديدة'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                    autofocus: true,
                    decoration: const InputDecoration(labelText: 'اسم المادة'),
                    onChanged: (value) => name = value),
                const SizedBox(height: 12),
                TextField(
                    decoration:
                        const InputDecoration(labelText: 'الرمز (اختياري)'),
                    onChanged: (value) => code = value)
              ]),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('إلغاء')),
                FilledButton(
                    onPressed: () async {
                      if (name.trim().isEmpty) return;
                      await context
                          .read<AppState>()
                          .addSubject(name, code: code);
                      if (dialogContext.mounted) Navigator.pop(dialogContext);
                    },
                    child: const Text('حفظ'))
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
      return const Center(
          child: Text('لا توجد مهام حالياً\nاضغط إضافة لإنشاء أول مهمة.',
              textAlign: TextAlign.center));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, index) => AppCard(
          child: ListTile(
              leading: const Icon(Icons.radio_button_unchecked),
              title: Text(tasks[index].title),
              subtitle: const Text('مهمة شخصية'))),
    );
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
