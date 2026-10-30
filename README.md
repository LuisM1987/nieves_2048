# Nieves 2048 (TDD)

Clon de 2048 con sabores de nieve de Dolores Hidalgo, construido con TDD en Flutter.
Logica en Dart puro (`lib/logica`), interfaz con degradados y animaciones en `lib/presentation`.

## Como ponerlo a andar

1. Descomprime el zip y abre la carpeta `nieves_2048` en VS Code.
2. En la terminal, dentro de la carpeta, agrega las plataformas:

       flutter create . --platforms=android,web

3. Descarga dependencias y corre las pruebas (deben pasar 20 en verde):

       flutter pub get
       flutter test --reporter expanded

4. Ejecuta la app:

       flutter run -d edge        # web (mouse o flechas del teclado)
       flutter run                # Android (emulador o telefono)
