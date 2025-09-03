/*
 * @class CustomFooter
 * @description Clase encargada de mostrar el pie de página personalizado.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  // Índice de la pestaña actual
  final int currentIndex;
  // Función del icono presionado
  final Function(int) onTap;

  const CustomFooter({Key? key, required this.currentIndex, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      // Item de la pestaña "Inicio"
      _FooterItem(icon: Icons.home, label: 'Inicio', selected: currentIndex == 0, onTap: () => onTap(0)),
      // Item de la pestaña "Planetas"
      _FooterItem(icon: Icons.public, label: 'Planetas', selected: currentIndex == 1, onTap: () => onTap(1)),
      // Item de la pestaña "Favoritos"
      _FooterItem(icon: Icons.favorite, label: 'Favoritos', selected: currentIndex == 2, onTap: () => onTap(2)),
    ];
    return SafeArea(
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: items),
      ),
    );
  }
}

class _FooterItem extends StatelessWidget {
  // Icono del item
  final IconData icon;
  // Etiqueta del item
  final String label;
  // Estado de selección del item
  final bool selected;
  // Función del icono presionado
  final VoidCallback onTap;

  const _FooterItem({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Color del icono del item
    final iconColor = Color(0xFF004766);
    // Color del texto del item
    final textColor = Color(0xFF004766);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(bottom: selected ? 8 : 0),
            child: Transform.translate(
              offset: selected ? const Offset(0, -16) : Offset.zero,
              child: Container(
                decoration: BoxDecoration(
                  color: selected ? Colors.white.withOpacity(0.18) : Colors.transparent,
                  shape: BoxShape.circle,
                  boxShadow: selected
                      ? [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 2))]
                      : [],
                ),
                padding: const EdgeInsets.all(10),
                // Icono del item
                child: Icon(icon, color: iconColor, size: selected ? 32 : 28),
              ),
            ),
          ),
          const SizedBox(height: 2),
          // Etiqueta del item
          Transform.translate(
            offset: selected ? const Offset(0, -16) : Offset.zero,
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: selected ? 14 : 12,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
