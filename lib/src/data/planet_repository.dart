/*
 * @class PlanetRepository
 * @description Clase encargada de gestionar la información de los planetas.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import 'package:shared_preferences/shared_preferences.dart';
import 'planet_api.dart';
import '../domain/entities/planet.dart';

class PlanetRepository {
  // API
  final PlanetApi api;
  // Repositorio
  PlanetRepository({PlanetApi? api}) : api = api ?? PlanetApi();

  /*
   * @method getPlanets
   * @description Método encargado de obtener todos los planetas.
   * @returns Lista de planetas.
   */
  Future<List<Planet>> getPlanets() => api.fetchPlanets();

  /*
   * @method getPlanet
   * @description Método encargado de obtener un planeta mediante su ID.
   * @param id ID del planeta a obtener.
   * @returns Planeta correspondiente al ID proporcionado.
   */
  Future<Planet> getPlanet(String id) => api.fetchPlanetById(id);

  /*
   * @method getFavorites
   * @description Método encargado de obtener los planetas favoritos del usuario
   * @returns Conjunto de IDs de planetas favoritos.
   */
  Future<Set<String>> getFavorites() async {
    final sp = await SharedPreferences.getInstance();
    final list = sp.getStringList('favorites') ?? <String>[];
    return list.toSet();
  }

  /*
   * @method toggleFavorite
   * @description Método encargado de agregar o eliminar un planeta de los favoritos del usuario
   */
  Future<void> toggleFavorite(String id) async {
    final sp = await SharedPreferences.getInstance();
    final list = sp.getStringList('favorites') ?? <String>[];
    final set = list.toSet();
    if (set.contains(id)) {
      set.remove(id);
    } else {
      set.add(id);
    }
    await sp.setStringList('favorites', set.toList());
  }
}
