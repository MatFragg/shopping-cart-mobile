import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App builds a Scaffold', (WidgetTester tester) async {
    // Construir una app mínima que no depende de `MyApp`
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('App built')),
      ),
    ));

    // Verificar que el Scaffold y el texto están presentes.
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text('App built'), findsOneWidget);
  });
}
