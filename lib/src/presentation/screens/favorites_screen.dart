/*
 * @class FavoritesScreen
 * @description Clase encargada de mostrar los planetas seleccionados como favoritos.
 * @autor Angela Andrade
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_footer.dart';
import '../widgets/generic_appbar.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GenericAppBar(),
      body: const Center(child: Text('Favoritos')),
      // Footer
      bottomNavigationBar: CustomFooter(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            context.go('/home');
          } else if (index == 1) {
            context.go('/planets');
          } else if (index == 2) {
            // ya está en favoritos
          }
        },
      ),
    );
  }
}
