# Tres Astronautas App

Aplicación Flutter para la gestión y visualización de la información de los planetas, con animaciones interactivas usando la librería Lottie.

## Requisitos Técnicos

- **Manejo del Estado:** Riverpod para gestión global y reactiva del estado.
- **Arquitectura:** Limpia, con separación en capas: presentación, dominio y datos.
- **Consumo de API REST:** Obtención de información de planetas desde un API público.
- **Navegación:** go_router para rutas principales, rutas dinámicas y parámetros de URL.
- **Responsividad:** Adaptación a móvil, tablet y escritorio.
- **Despliegue:** Aplicación desplegada en Firebase Hosting.

## Estructura del Proyecto

- `lib/src/presentation/`: Pantallas y widgets de UI.
- `lib/src/domain/`: Entidades y lógica de negocio.
- `lib/src/data/`: Acceso a datos y consumo de API REST.
- `lib/src/providers/`: Providers de Riverpod.
- `lib/main.dart`: Configuración principal y rutas.

## Ejecución Local

1. Clona el repositorio:
	```sh
	git clone https://github.com/JohanaAndrade0610/tres_astronautas_app.git
	cd tres_astronautas_app
	```
2. Instala dependencias:
	```sh
	flutter pub get
	```
3. Ejecuta la app:
	```sh
	flutter run
	```
	Para web:
	```sh
	flutter run -d chrome
	```

## Despliegue en Firebase Hosting

1. Instala Firebase CLI:
	```sh
	npm install -g firebase-tools
	```
2. Inicia sesión:
	```sh
	firebase login
	```
3. Inicializa Firebase Hosting en el proyecto:
	```sh
	firebase init hosting
	```
	- Selecciona el proyecto de Firebase.
	- Usa `build/web` como carpeta pública.
	- Configura como SPA (Single Page App) si se solicita.
4. Compila la app para web:
	```sh
	flutter build web
	```
5. Despliega:
	```sh
	firebase deploy
	```

## Decisiones Técnicas

- **Riverpod:** Permite un manejo de estado escalable y reactivo.
- **Arquitectura limpia:** Facilita la mantenibilidad y escalabilidad.
- **go_router:** Navegación declarativa y manejo de rutas dinámicas.
- **Responsividad:** Uso de helpers y layouts adaptativos para distintos dispositivos.
- **Consumo de API REST:** Separación clara entre datos y presentación.
- **Animaciones con Lottie:** Se incluyeron animaciones interactivas usando la librería [Lottie](https://pub.dev/packages/lottie) para mejorar la experiencia visual y de usuario.

## URL de la aplicación desplegada

> [Agrega aquí la URL de Firebase Hosting cuando completes el despliegue]

## Autor

Angela Andrade

---
¿Dudas o sugerencias? Puedes abrir un issue en el repositorio.
