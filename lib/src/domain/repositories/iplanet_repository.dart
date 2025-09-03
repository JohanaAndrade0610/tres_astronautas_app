/*
 * @abstract class IPlanetRepository
 * @description Repositorio abstracto para la capa de dominio.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import '../entities/planet.dart';

abstract class IPlanetRepository {
  /*
   * @method getPlanets
   * @description Método encargado de obtener la lista de planetas.
   */
  Future<List<Planet>> getPlanets();

  /*
   * @method getPlanet
   * @description Método encargado de obtener un planeta mediante su ID.
   * @param id ID del planeta a obtener.
   */
  Future<Planet> getPlanet(String id);

  /*
   * @method getFavorites
   * @description Método encargado de obtener los planetas favoritos del usuario.
   */
  Future<Set<String>> getFavorites();

  /*
   * @method toggleFavorite
   * @description Método encargado de agregar o quitar un planeta de los favoritos del usuario.
   * @param id ID del planeta a agregar o quitar de favoritos.
   */
  Future<void> toggleFavorite(String id);
}
