import 'package:flutter_test/flutter_test.dart';
import 'package:conviva/app.dart';

void main() {
  testWidgets('ConvivaApp renders Home for senior with mock events', (WidgetTester tester) async {
    await tester.pumpWidget(const ConvivaApp());
    await tester.pumpAndSettle();

    // Verify senior home greets Dona Marta as in 01-home.png
    expect(find.textContaining('Dona Marta'), findsWidgets);
    // Verify event card from 01-home.png
    expect(find.text('Bazar de Artesanato'), findsOneWidget);
    expect(find.text('Tarde de Bingo Solidário'), findsOneWidget);
  });
}
