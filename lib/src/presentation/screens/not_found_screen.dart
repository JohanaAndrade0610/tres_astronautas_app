/*
 * @class NotFoundScreen
 * @description Clase encargada de mostrar la pantalla de Planeta no encontrado.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:tres_astronautas_app/src/presentation/widgets/generic_appbar.dart';
import '../widgets/_animated_blue_border_button.dart';
import '../widgets/custom_footer.dart';
import '../utils/screen_helper.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GenericAppBar(),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final deviceType = ScreenHelper.getDeviceType(context);
            final imageWidth = ScreenHelper.getResponsiveSize(context, mobile: 1, tablet: 0.8, desktop: 0.5);
            // Diseño para dispositivos de escritorio
            if (deviceType == DeviceType.desktop) {
              return Padding(
                padding: const EdgeInsets.only(left: 150.0, right: 150.0),
                child: Row(
                  children: [
                    Lottie.asset('assets/lottie/not_found.json', width: imageWidth, fit: BoxFit.contain),
                    AnimatedBlueBorderButton(
                      onPressed: () => context.go('/planets'),
                      child: const Text(
                        'Volver al listado',
                        style: TextStyle(color: Color(0xFF004766), fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }
            // Diseño para dispositivos móviles y tablets
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/lottie/not_found.json', width: imageWidth, fit: BoxFit.contain),
                const SizedBox(height: 50),
                AnimatedBlueBorderButton(
                  onPressed: () => context.go('/planets'),
                  child: const Text(
                    'Ir al listado',
                    style: TextStyle(color: Color(0xFF004766), fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      // Footer
      bottomNavigationBar: CustomFooter(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            context.go('/home');
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
