import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:student_grades/main.dart';

void main() {
  testWidgets('shows average and updates it when a grade changes',
      (tester) async {
    await tester.pumpWidget(const GradesApp());

    // (92 + 71 + 54 + 48) / 4 = 66.25
    expect(find.text('ממוצע: 66.3'), findsOneWidget);
    expect(find.text('ציון: 54'), findsOneWidget);

    // Raise Yosef (54) by one: he should now pass.
    final yosefRow = find.ancestor(
      of: find.text('יוסף'),
      matching: find.byType(StudentTile),
    );
    await tester.tap(
      find.descendant(of: yosefRow, matching: find.byIcon(Icons.add)),
    );
    await tester.pump();

    expect(find.text('ציון: 55'), findsOneWidget);
    expect(find.text('ממוצע: 66.5'), findsOneWidget);
    expect(
      find.descendant(of: yosefRow, matching: find.byIcon(Icons.check_circle)),
      findsOneWidget,
    );
  });
}
