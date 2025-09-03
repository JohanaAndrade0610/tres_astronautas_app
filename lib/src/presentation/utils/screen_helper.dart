/*
 * @class ScreenHelper
 * @description Clase encargada de determinar el tipo de dispositivo.
 * @autor Angela Andrade
 * @version 1.0 03/09/2025 Documentación y creación de la clase.
 */

import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop }

class ScreenHelper {
  /*
   * @method getDeviceType
   * @description Método estático para obtener el tipo de dispositivo.
   * @return DeviceType
   */
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) {
      return DeviceType.desktop;
    } else if (width >= 728 && width < 1024) {
      return DeviceType.tablet;
    } else {
      return DeviceType.mobile;
    }
  }

  /**
   * @method getResponsiveSize
   * @description Método estático para obtener un tamaño responsivo según el tipo de dispositivo.
   * @return double
   */
  static double getResponsiveSize(
    BuildContext context, {
    double mobile = 0.5,
    double tablet = 0.4,
    double desktop = 0.3,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.desktop:
        return MediaQuery.of(context).size.width * desktop;
      case DeviceType.tablet:
        return MediaQuery.of(context).size.width * tablet;
      case DeviceType.mobile:
      default:
        return MediaQuery.of(context).size.width * mobile;
    }
  }
}
