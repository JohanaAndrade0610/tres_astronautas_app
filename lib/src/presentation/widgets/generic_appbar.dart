/*
 * @class GenericAppBar
 * @description Clase encargada de mostrar la barra de aplicación genérica.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GenericAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackArrow;
  const GenericAppBar({Key? key, this.showBackArrow = false}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Stack(
        alignment: Alignment.center,
        children: [
          // Logo Tres Astronautas
          Image.asset('assets/images/three_astronauts_logo.png', height: 36),
          // Flecha de retroceso alineada a la izquierda (solo si showBackArrow = true)
          if (showBackArrow)
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF004766)),
                  onPressed: () {
                    // Navegación hacia la ventana anterior
                    if (Navigator.of(context).canPop()) {
                      context.pop();
                    } else {
                      context.go('/planets');
                    }
                  },
                ),
              ),
            ),
        ],
      ),
      centerTitle: true,
      titleSpacing: 0,
    );
  }
}
