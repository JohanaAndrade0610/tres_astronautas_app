/*
 * @class AnimatedBlueBorderButton
 * @description Clase encargada de mostrar la animación del botón "Ver Planetas"
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import 'package:flutter/material.dart';

class AnimatedBlueBorderButton extends StatefulWidget {
  // Contenido del botón
  final Widget child;
  // Acción del botón
  final VoidCallback? onPressed;
  // Ancho del botón
  final double width;
  // Alto del botón
  final double height;
  const AnimatedBlueBorderButton({
    required this.child,
    this.onPressed,
    this.width = 200,
    this.height = 50,
    Key? key,
  }) : super(key: key);

  @override
  State<AnimatedBlueBorderButton> createState() => AnimatedBlueBorderButtonState();
}

class AnimatedBlueBorderButtonState extends State<AnimatedBlueBorderButton> with SingleTickerProviderStateMixin {
  // Controlador de animación
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Aura arcoíris difusa
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.redAccent.withOpacity(0.25), blurRadius: 32, spreadRadius: 2),
                BoxShadow(color: Colors.orangeAccent.withOpacity(0.18), blurRadius: 40, spreadRadius: 2),
                BoxShadow(color: Colors.yellowAccent.withOpacity(0.15), blurRadius: 48, spreadRadius: 2),
                BoxShadow(color: Colors.greenAccent.withOpacity(0.15), blurRadius: 56, spreadRadius: 2),
                BoxShadow(color: Colors.blueAccent.withOpacity(0.15), blurRadius: 64, spreadRadius: 2),
                BoxShadow(color: Colors.purpleAccent.withOpacity(0.15), blurRadius: 72, spreadRadius: 2),
              ],
            ),
          ),
          // Botón principal
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE0E2EF),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF004766), width: 3),
            ),
            alignment: Alignment.center,
            child: widget.child,
          ),
          // Overlay eliminado: no hay efecto visual al presionar
          GestureDetector(
            onTap: widget.onPressed,
            behavior: HitTestBehavior.translucent,
            child: Container(
              width: widget.width,
              height: widget.height,
            ),
          ),
        ],
      ),
    );
  }
}