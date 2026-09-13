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
      builder: (context) => const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Wrap(
            runSpacing: 8,
            children: [
              ListTile(
                  leading: Icon(Icons.check_circle_outline),
                  title: Text('مهمة شخصية')),
              ListTile(
                  leading: Icon(Icons.assignment_outlined),
                  title: Text('واجب جامعي')),
              ListTile(
                  leading: Icon(Icons.quiz_outlined),
                  title: Text('Quiz أو امتحان')),
              ListTile(
                  leading: Icon(Icons.note_add_outlined),
                  title: Text('ملاحظة')),
              ListTile(
                  leading: Icon(Icons.shopping_basket_outlined),
                  title: Text('عملية شراء')),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
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
