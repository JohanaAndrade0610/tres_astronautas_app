/*
 * @class GenericLoading
 * @description Clase encargada de mostrar la ventana de carga.
 * @autor Angela Andrade
 * @version 1.0 03/09/2025 Documentación y creación de la clase.
 */

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'generic_appbar.dart';
import '../utils/screen_helper.dart';

class GenericLoading extends StatefulWidget {
  const GenericLoading({super.key, this.size = 420, this.message = 'Cargando, por favor espere...'});

  // Tamaño de la animación
  final double size;
  // Texto que se muestra encima de la animación.
  final String message;
  // Ruta de la animación Lottie
  static const _assetPath = 'assets/lottie/astronaut.json';

  @override
  State<GenericLoading> createState() => _GenericLoadingState();
}

class _GenericLoadingState extends State<GenericLoading> with SingleTickerProviderStateMixin {
  // Controlador de la animación
  late final AnimationController _controller;

  /*
 * @method initState
 * @description Método encargado de inicializar el estado de la ventana de carga.
 */
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  /*
 * @method dispose
 * @description Método encargado de liberar los recursos utilizados por la ventana de carga.
 */
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const GenericAppBar(),
          body: Center(
            child: Builder(
              builder: (context) {
                final imageWidth = ScreenHelper.getResponsiveSize(context, mobile: 1, tablet: 0.8, desktop: 0.5);
                return Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  // Animación de astronauta
                  child: LottieBuilder.asset(
                    GenericLoading._assetPath,
                    controller: _controller,
                    width: imageWidth,
                    fit: BoxFit.contain,
                    onLoaded: (composition) {
                      _controller.duration = composition.duration;
                      _controller.repeat();
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
