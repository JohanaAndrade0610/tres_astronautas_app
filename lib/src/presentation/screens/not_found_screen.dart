/*
 * @class NotFoundScreen
 * @description Clase encargada de mostrar la pantalla de Planeta no encontrado.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_footer.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('No encontrado')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('La página solicitada no existe.'),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () => context.go('/planets'), child: const Text('Ir al listado')),
          ],
        ),
      ),
      bottomNavigationBar: CustomFooter(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            context.go('/');
          } else if (index == 1) {
            context.go('/planets');
          } else if (index == 2) {
            context.go('/favorites');
          }
        },
      ),
    );
  }
}
