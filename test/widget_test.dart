// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:campus_hub/main.dart';
import 'package:campus_hub/nevtreh.dart';

void main() {
  testWidgets('Demo login opens the app', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusApp());

    expect(find.byType(SchoolLoginScreen), findsOneWidget);
    expect(find.text('Оюутны код'), findsOneWidget);

    final demoLoginButton = find.text('Демо эрхээр нэвтрэх');
    await tester.ensureVisible(demoLoginButton);
    await tester.pumpAndSettle();
    await tester.tap(demoLoginButton);
    await tester.pumpAndSettle();

    expect(find.byType(Shell), findsOneWidget);
  });
}
