import 'package:flutter_test/flutter_test.dart';
import 'package:talib_al_jamia/main.dart';

void main() {
  testWidgets('renders the Arabic dashboard and primary navigation',
      (tester) async {
    await tester.pumpWidget(const TalibAlJamiaApp());

    expect(find.text('رتّب يومك بهدوء'), findsOneWidget);
    expect(find.text('الرئيسية'), findsAtLeastNWidgets(1));
    expect(find.text('الجامعة'), findsOneWidget);
    expect(find.text('إضافة'), findsOneWidget);
  });
}
