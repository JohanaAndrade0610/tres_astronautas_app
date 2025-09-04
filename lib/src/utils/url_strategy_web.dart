/*
 * @method configureUrlStrategy
 * @description Configura la estrategia de URL para la aplicación wen.
 * @autor Angela Andrade
 * @version 1.0 02/09/2025 Documentación y creación de la clase.
 */

import 'package:url_strategy/url_strategy.dart';

void configureUrlStrategy() {
  // Se elimina el hash de las URL en la web (se llama al helper proporcionado por el paquete)
  setPathUrlStrategy();
}
