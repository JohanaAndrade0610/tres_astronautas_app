/*
 * @class widget_test
 * @description Clase encargada de gestionar las pruebas de widgets.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import 'package:flutter_test/flutter_test.dart';

import 'package:tres_astronautas_app/main.dart';

void main() {
  testWidgets('La aplicación muestra el botón Ver Planetas', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
    expect(find.text('Ver Planetas'), findsOneWidget);
  });
}
