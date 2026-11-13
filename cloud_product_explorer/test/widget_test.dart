
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_product_explorer/main.dart';

void main() {
  testWidgets('Cloud Store app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const CloudProductExplorer());

    expect(find.text('C L O U D   S T O R E'), findsOneWidget);
  });
}
