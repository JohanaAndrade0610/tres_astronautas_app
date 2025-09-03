/*
 * @class HomeScreen
 * @description Clase encargada de mostrar la pantalla principal de la aplicación.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tres_astronautas_app/src/presentation/widgets/generic_appbar.dart';
import 'package:tres_astronautas_app/src/presentation/widgets/generic_loading.dart';
import '../widgets/custom_footer.dart';
import '../widgets/_animated_blue_border_button.dart';
import '../../providers/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Imagen del astronauta
            Positioned.fill(
              child: Image.asset(
                'assets/images/general_wallpaper.png',
                fit: BoxFit.fitHeight,
                alignment: Alignment.center,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  // AppBar
                  GenericAppBar(),
                  // Botón "Ver Planetas"
                  Expanded(
                    child: Align(
                      alignment: const Alignment(0, -0.4),
                      child: AnimatedBlueBorderButton(
                        width: 200,
                        height: 50,
                        onPressed: () async {
                          // Indicador de carga
                          final navigator = Navigator.of(context);
                          navigator.push(
                            MaterialPageRoute(
                              builder: (_) => const GenericLoading(message: 'Cargando planetas, por favor espere...'),
                            ),
                          );
                          final start = DateTime.now();
                          try {
                            // Forzar la carga del provider y esperar a que finalice
                            // ignore: unused_result
                            await ref.refresh(planetsListProvider.future);
                            // Asegurar tiempo mínimo de 2s para mostrar la animación
                            final elapsed = DateTime.now().difference(start);
                            final remaining = Duration(seconds: 2) - elapsed;
                            if (remaining > Duration.zero) await Future.delayed(remaining);
                            navigator.pop();
                            context.go('/planets');
                          } catch (e) {
                            navigator.pop();
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text('Error cargando planetas: $e')));
                          }
                        },
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
