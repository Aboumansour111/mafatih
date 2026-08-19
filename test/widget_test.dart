import 'package:flutter_test/flutter_test.dart';

import 'package:mafatih_yamani/main.dart';

void main() {
  testWidgets('Mafatih app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MafatihApp());

    expect(find.byType(MafatihApp), findsOneWidget);
  });
}
