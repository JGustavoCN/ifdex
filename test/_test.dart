import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ifdex/widgets/remove_button.dart';

void main() {
  group('RemoveButton Widget Test', () {
    testWidgets('deve exibir o ícone de remover e tooltip', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: RemoveButton(onPressed: () {})),
        ),
      );

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      expect(find.byTooltip('Remover'), findsOneWidget);
    });

    testWidgets('deve chamar onPressed ao clicar no botão', (
      WidgetTester tester,
    ) async {
      var clicked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RemoveButton(
              onPressed: () {
                clicked = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(clicked, true);
    });
  });
}
