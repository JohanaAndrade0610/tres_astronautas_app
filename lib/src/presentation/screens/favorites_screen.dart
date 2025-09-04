/*
 * @class FavoritesScreen
 * @description Clase encargada de mostrar los planetas seleccionados como favoritos.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_footer.dart';
import '../widgets/generic_appbar.dart';
import 'package:flutter/services.dart';
import '../../providers/providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Repositorio de favoritos
    final asyncFavorites = ref.watch(favoritesProvider);
    // Repositorio de planetas
    final asyncPlanets = ref.watch(planetsListProvider);

    return Stack(
      children: [
        // Fondo de pantalla
        Positioned.fill(
          child: Image.asset('assets/images/general_wallpaper.png', fit: BoxFit.fitHeight, alignment: Alignment.center),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          // AppBar
          appBar: const GenericAppBar(),
          // Lista de planetas favoritos
          body: SafeArea(
            child: asyncFavorites.when(
              data: (favIds) {
                return asyncPlanets.when(
                  data: (planets) {
                    final favoritePlanets = planets.where((p) => favIds.contains(p.id)).toList();
                    return ListView.builder(
                      itemCount: favoritePlanets.length,
                      itemBuilder: (context, i) {
                        final p = favoritePlanets[i];
                        final assetPath = 'assets/images/planets/${p.name.toLowerCase()}.png';
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                          child: Card(
                            color: const Color(0xFFE0E2EF).withOpacity(0.8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            child: ListTile(
                              title: Text(
                                p.name,
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0, bottom: 1.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Lunas: ${p.moons}', style: const TextStyle(fontSize: 11)),
                                    Text('Masa: ${p.massKg ?? 'Desconocida'}', style: const TextStyle(fontSize: 11)),
                                    Text(
                                      'Distancia orbital: ${p.orbitalDistanceKm?.toStringAsFixed(0) ?? 'Desconocida'} km',
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              leading: FutureBuilder<bool>(
                                future: rootBundle.load(assetPath).then((_) => true).catchError((_) => false),
                                builder: (context, snapshot) {
                                  // Verificar si la imagen del planeta existe en los assets
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.data == true) {
                                    return CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.grey.shade300,
                                      backgroundImage: AssetImage(assetPath),
                                    );
                                  } else {
                                    // Si la imagen no existe, mostrar un ícono de imagen rota
                                    return const CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.grey,
                                      child: Icon(Icons.broken_image, color: Colors.black45),
                                    );
                                  }
                                },
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.favorite, color: Colors.red),
                                tooltip: 'Quitar de favoritos',
                                onPressed: () async {
                                  try {
                                    await ref.read(favoritesProvider.notifier).toggle(p.id);
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(SnackBar(content: Text('Eliminado de favoritos')));
                                  } catch (e) {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(SnackBar(content: Text('Error actualizando favorito: $e')));
                                  }
                                },
                              ),
                              onTap: () {
                                context.go('/planets/${Uri.encodeComponent(p.id)}', extra: p);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('Error: $e')),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
          bottomNavigationBar: CustomFooter(
            currentIndex: 2,
            onTap: (index) {
              if (index == 0) {
                context.go('/home');
              } else if (index == 1) {
                context.go('/planets');
              } else if (index == 2) {
                // ya está en favoritos
              }
            },
          ),
        ),
      ],
    );
  }
}
