import 'package:flutter_test/flutter_test.dart';
import 'package:object_detection/main.dart';

void main() {
  testWidgets('Object Detection App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const ObjectVisionApp());

    expect(find.text('Object Detection'), findsOneWidget);
  });
}