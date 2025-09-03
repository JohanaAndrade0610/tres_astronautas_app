/*
 * @class GetPlanetsUseCase
 * @description Caso de uso para obtener todos los planetas.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import '../repositories/iplanet_repository.dart';
import '../entities/planet.dart';

class GetPlanetsUseCase {
  // Repositorio de planetas
  final IPlanetRepository repository;
  // Constructor
  GetPlanetsUseCase(this.repository);

  /*
   * @method call
   * @description Método encargado de ejecutar el caso de uso.
   * @returns Lista de planetas.
   */
  Future<List<Planet>> call() async {
    return await repository.getPlanets();
  }
}
