/*
 * @class PlanetsListScreen
 * @description Clase encargada de mostrar la pantalla de listado de planetas.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_footer.dart';
import '../widgets/generic_appbar.dart';
import '../widgets/generic_loading.dart';
import '../../providers/providers.dart';

class PlanetsListScreen extends ConsumerStatefulWidget {
  // Constructor
  const PlanetsListScreen({super.key});

  @override
  ConsumerState<PlanetsListScreen> createState() => _PlanetsListScreenState();
}

class _PlanetsListScreenState extends ConsumerState<PlanetsListScreen> {
  // Filtro de búsqueda
  String filter = '';

  /*
   * @method _highlightOccurrences
   * @description Método encargado de resaltar las coincidencias del filtro.
   */
  TextSpan _highlightOccurrences(String source, String query, TextStyle normalStyle, TextStyle highlightStyle) {
    if (query.isEmpty) return TextSpan(text: source, style: normalStyle);

    final lowerSource = source.toLowerCase();
    final lowerQuery = query.toLowerCase();
    int start = 0;
    final children = <TextSpan>[];

    while (true) {
      final index = lowerSource.indexOf(lowerQuery, start);
      if (index < 0) {
        children.add(TextSpan(text: source.substring(start), style: normalStyle));
        break;
      }
      if (index > start) {
        children.add(TextSpan(text: source.substring(start, index), style: normalStyle));
      }
      children.add(TextSpan(text: source.substring(index, index + lowerQuery.length), style: highlightStyle));
      start = index + lowerQuery.length;
    }

    return TextSpan(children: children, style: normalStyle);
  }

  /*
   * @method _assetExists
   * @description Método encargado de verificar si la imagen del planeta existe en el bundle.
   */
  Future<bool> _assetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncPlanets = ref.watch(planetsListProvider);

    return Stack(
      children: [
        // Imagen del astronauta
        Positioned.fill(
          child: Image.asset('assets/images/general_wallpaper.png', fit: BoxFit.fitHeight, alignment: Alignment.center),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const GenericAppBar(),
          body: SafeArea(
            child: Column(
              children: [
                // Filtro de búsqueda
                Padding(
                  padding: const EdgeInsets.only(left: 22.0, right: 22.0, bottom: 12.0),
                  child: Container(
                    decoration: BoxDecoration(color: const Color(0xFFE0E2EF), borderRadius: BorderRadius.circular(24)),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar planeta',
                        prefixIcon: const Icon(Icons.search),
                        border: InputBorder.none,
                        labelStyle: const TextStyle(color: Colors.black54),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                      ),
                      style: const TextStyle(color: Colors.black),
                      onChanged: (v) => setState(() => filter = v.toLowerCase()),
                    ),
                  ),
                ),
                // Lista de planetas
                Expanded(
                  child: asyncPlanets.when(
                    data: (list) {
                      final filtered = list.where((p) {
                        final combined = '${p.name} ${p.massKg} ${p.orbitalDistanceKm?.toStringAsFixed(0)}'
                            .toLowerCase();
                        return combined.contains(filter);
                      }).toList();
                      return ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final p = filtered[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                            // Card de cada planeta
                            child: Card(
                              color: const Color(0xFFE0E2EF).withOpacity(0.7),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              // Nombre del planeta
                              child: ListTile(
                                title: RichText(
                                  text: _highlightOccurrences(
                                    p.name,
                                    filter,
                                    const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      backgroundColor: const Color(0x66004766),
                                    ),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                // Descripción del planeta
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4.0, bottom: 1.0),
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(color: Colors.black54, fontSize: 11),
                                      children: [
                                        // Cantidad de lunas
                                        TextSpan(
                                          text: 'Lunas: ',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        _highlightOccurrences(
                                          // Resaltar coincidencias en caso de que existan
                                          '${p.moons}\n',
                                          filter,
                                          const TextStyle(color: Colors.black54, fontSize: 11),
                                          TextStyle(
                                            color: Colors.black54,
                                            fontSize: 11,
                                            backgroundColor: const Color(0x66004766),
                                          ),
                                        ),
                                        // Masa del planeta
                                        TextSpan(
                                          text: 'Masa: ',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        _highlightOccurrences(
                                          // Resaltar coincidencias en caso de que existan
                                          p.massKg != null ? '${p.massKg} kg\n' : 'Desconocida\n',
                                          filter,
                                          const TextStyle(color: Colors.black54, fontSize: 11),
                                          TextStyle(
                                            color: Colors.black54,
                                            fontSize: 11,
                                            backgroundColor: const Color(0x66004766),
                                          ),
                                        ),
                                        // Distancia orbital del planeta
                                        TextSpan(
                                          text: 'Distancia orbital: ',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        _highlightOccurrences(
                                          // Resaltar coincidencias en caso de que existan
                                          p.orbitalDistanceKm != null
                                              ? '${p.orbitalDistanceKm!.toStringAsFixed(0)} km'
                                              : 'Desconocida',
                                          filter,
                                          const TextStyle(color: Colors.black54, fontSize: 11),
                                          TextStyle(
                                            color: Colors.black54,
                                            fontSize: 11,
                                            backgroundColor: const Color(0x66004766),
                                          ),
                                        ),
                                      ],
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                                // Imagen del planeta
                                leading: FutureBuilder<bool>(
                                  future: _assetExists('assets/images/planets/${p.name.toLowerCase()}.png'),
                                  builder: (context, snapshot) {
                                    final assetPath = 'assets/images/planets/${p.name.toLowerCase()}.png';
                                    // Si la imagen existe en la carpeta de assets se utiliza esa imagen
                                    if (snapshot.connectionState == ConnectionState.done && snapshot.data == true) {
                                      return CircleAvatar(
                                        radius: 28,
                                        backgroundColor: Colors.grey.shade300,
                                        backgroundImage: AssetImage(assetPath),
                                      );
                                    }
                                    // Si la imagen no existe en la carpeta de assets se utiliza la URL de la imagen
                                    else if (p.imageUrl != null && p.imageUrl!.isNotEmpty) {
                                      return CircleAvatar(
                                        radius: 28,
                                        backgroundColor: Colors.grey.shade300,
                                        backgroundImage: NetworkImage(p.imageUrl!),
                                        onBackgroundImageError: (_, __) =>
                                            const Icon(Icons.broken_image, color: Colors.black45),
                                      );
                                    }
                                    // Si la imagen no existe en la carpeta ni tiene una URL se muestra un icono de imagen rota
                                    else {
                                      return const CircleAvatar(
                                        radius: 28,
                                        backgroundColor: Colors.grey,
                                        child: Icon(Icons.broken_image, color: Colors.black45),
                                      );
                                    }
                                  },
                                ),
                                onTap: () async {
                                  // Mostrar loading y pre-cargar datos del planeta seleccionado
                                  final navigator = Navigator.of(context);
                                  final start = DateTime.now();
                                  navigator.push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const GenericLoading(message: 'Cargando información, por favor espere...'),
                                    ),
                                  );
                                  try {
                                    final repo = ref.read(planetRepositoryProvider);
                                    final planet = await repo.getPlanet(p.id);
                                    // Asegurar mínimo 2s de visualización del loading
                                    final elapsed = DateTime.now().difference(start);
                                    final remaining = Duration(seconds: 2) - elapsed;
                                    if (remaining > Duration.zero) await Future.delayed(remaining);
                                    navigator.pop();
                                    // Navegar pasando el id; PlanetDetailScreen ahora puede aceptar initial data
                                    context.go('/planets/${Uri.encodeComponent(p.id)}', extra: planet);
                                  } catch (e) {
                                    navigator.pop();
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(SnackBar(content: Text('Error cargando planeta: $e')));
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()), // Indicador de carga
                    error: (e, st) => Center(child: Text('Error: $e')),
                  ),
                ),
              ],
            ),
          ),
          // Footer
          bottomNavigationBar: CustomFooter(
            currentIndex: 1,
            onTap: (index) {
              if (index == 0) {
                context.go('/home');
              } else if (index == 1) {
                // Ya está en Planets
              } else if (index == 2) {
                context.go('/favorites');
              }
            },
          ),
        ),
      ],
    );
  }
}
