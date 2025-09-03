/*
 * @class GenericLoading
 * @description Clase encargada de mostrar la ventana de carga.
 * @autor Angela Andrade
 * @version 1.0 03/09/2025 Documentación y creación de la clase.
 */

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tres_astronautas_app/src/presentation/widgets/_animated_blue_border_button.dart';
import 'generic_appbar.dart';

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Texto "Cargando..."
                  AnimatedBlueBorderButton(
                    onPressed: null,
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                    child: Center(
                      child: Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF004766), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // Animación de carga
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Center(
                      child: LottieBuilder.asset(
                        GenericLoading._assetPath,
                        controller: _controller,
                        fit: BoxFit.contain,
                        onLoaded: (composition) {
                          // Controlador de la animación
                          _controller.duration = composition.duration;
                          _controller.repeat();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
