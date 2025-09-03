/*
 * @class Providers
 * @description Clase encargada de gestionar el estado de la aplicación.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/planet_api.dart';
import '../data/planet_repository.dart';
import '../domain/entities/planet.dart';

// Proveedores de la aplicación
final planetApiProvider = Provider((ref) => PlanetApi());
// Repositorio de planetas
final planetRepositoryProvider = Provider((ref) => PlanetRepository(api: ref.read(planetApiProvider)));
// Proveedor de la lista de planetas
final planetsListProvider = FutureProvider<List<Planet>>((ref) async {
  final repo = ref.read(planetRepositoryProvider);
  return repo.getPlanets();
});
// Proveedor de Planetas favoritos
final favoritesProvider = AsyncNotifierProvider<FavoritesNotifier, Set<String>>(() => FavoritesNotifier());

class FavoritesNotifier extends AsyncNotifier<Set<String>> {
  // Repositorio de planetas
  late PlanetRepository _repo;

  /*
 * @method build
 * @description Método encargado de construir el estado inicial del proveedor.
 * @returns El estado inicial del proveedor y los planetas favoritos.
 */
  @override
  Future<Set<String>> build() async {
    _repo = PlanetRepository();
    final favs = await _repo.getFavorites();
    return favs;
  }

  /*
 * @method toggle
 * @description Método encargado de alternar el estado de favorito de un planeta.
 */
  Future<void> toggle(String id) async {
    state = const AsyncValue.loading();
    await _repo.toggleFavorite(id);
    state = AsyncValue.data(await _repo.getFavorites());
  }
}
