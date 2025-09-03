/*
 * @class HomeScreen
 * @description Clase encargada de mostrar la pantalla principal de la aplicación.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tres_astronautas_app/src/presentation/widgets/generic_appbar.dart';
import '../widgets/custom_footer.dart';
import '../widgets/_animated_blue_border_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // Fondo de la pantalla
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/background_home.png'), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  // AppBar
                  GenericAppBar(),
                  // Botón "Ver Planetas"
                  Expanded(
                    child: Align(
                      alignment: const Alignment(0, -0.39),
                      child: AnimatedBlueBorderButton(
                        onPressed: () => context.push('/planets'),
                        child: const Text(
                          'Ver Planetas',
                          style: TextStyle(color: Color(0xFF004766), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Footer
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomFooter(
                currentIndex: 0,
                onTap: (index) {
                  if (index == 0) {
                    // Ya está en Home
                  } else if (index == 1) {
                    context.go('/planets');
                  } else if (index == 2) {
                    context.go('/favorites');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
