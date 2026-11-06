import 'package:flutter_test/flutter_test.dart';
import 'package:alexa/main.dart';

void main() {
  testWidgets('AlexaApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AlexaApp());
    expect(find.byType(AlexaApp), findsOneWidget);
  });
}
