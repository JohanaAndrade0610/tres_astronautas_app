/*
 * @class PlanetApi
 * @description Clase encargada de realizar las peticiones a la API de planetas.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tres_astronautas_app/src/domain/entities/planet.dart';

class PlanetApi {
  // URL de la API publica
  final Uri base = Uri.parse('https://us-central1-a-academia-espacial.cloudfunctions.net/planets');

  /*
   * @method fetchPlanets
   * @description Método encargado de obtener la lista de planetas.
   * @returns Lista de planetas.
   */
  Future<List<Planet>> fetchPlanets() async {
    final resp = await http.get(base);
    if (resp.statusCode != 200) {
      throw Exception('Failed to load planets');
    }
    final data = json.decode(resp.body) as Map<String, dynamic>;
    final List items = (data['data'] as List?) ?? [];
    return items.map((e) => _planetFromJson(e as Map<String, dynamic>)).toList();
  }

  /*
   * @method fetchPlanetById
   * @description Método encargado de obtenerla información de un planeta mediante su ID.
   * @returns Información del planeta.
   */
  Future<Planet> fetchPlanetById(String id) async {
    final all = await fetchPlanets();
    final found = all.firstWhere(
      (p) => p.id.toLowerCase() == id.toLowerCase(),
      orElse: () => throw Exception('Not found'),
    );
    return found;
  }

  /*
   * @method _planetFromJson
   * @description Método encargado de convertir un JSON en un objeto Planet.
   * @returns Objeto Planet.
   */
  Planet _planetFromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      final s = v.toString().replaceAll(',', '').trim();
      return double.tryParse(s);
    }

    return Planet(
      id: (json['name'] ?? '').toString(),
      name: json['name'] ?? '',
      massKg: json['mass_kg']?.toString(),
      orbitalDistanceKm: parseDouble(json['orbital_distance_km'] ?? json['orbital_distnce_km']),
      imageUrl: (json['image'] ?? json['imageUrl'])?.toString(),
      description: json['description']?.toString(),
      moons: (json['moons'] is num) ? (json['moons'] as num).toInt() : int.tryParse(json['moons']?.toString() ?? ''),
    );
  }
}
