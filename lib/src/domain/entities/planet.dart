/*
 * @class Planet
 * @description Entidad de dominio para un planeta.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

class Planet {
  final String id; // Id del planeta
  final String name; // Nombre del planeta
  final String? massKg; // Masa del planeta en kilogramos
  final double? orbitalDistanceKm; // Distancia orbital en kilómetros
  final String? imageUrl; // URL de la imagen del planeta
  final String? description; // Descripción del planeta
  final int? moons; // Número de lunas del planeta

  Planet({
    required this.id,
    required this.name,
    this.massKg,
    this.orbitalDistanceKm,
    this.imageUrl,
    this.description,
    this.moons,
  });
}
