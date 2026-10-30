import 'package:flutter/material.dart';

class Ficha extends StatelessWidget {
  final int? valor;
  const Ficha({super.key, required this.valor});

  static const Map<int, List<Color>> _gradientes = {
    2: [Color(0xFFFFFDE7), Color(0xFFFFF9C4)],
    4: [Color(0xFFF8BBD0), Color(0xFFF48FB1)],
    8: [Color(0xFFD7CCC8), Color(0xFFA1887F)],
    16: [Color(0xFFFFE0B2), Color(0xFFFFB74D)],
    32: [Color(0xFFC8E6C9), Color(0xFF81C784)],
    64: [Color(0xFFE1BEE7), Color(0xFFBA68C8)],
    128: [Color(0xFF8D6E63), Color(0xFF4E342E)],
    256: [Color(0xFFFFE082), Color(0xFFFFC107)],
    512: [Color(0xFF6D4C41), Color(0xFF3E2723)],
    1024: [Color(0xFFFFF3E0), Color(0xFFFFCC80)],
    2048: [Color(0xFF006341), Color(0xFFFFFFFF)],
  };

  static const Map<int, String> _nombres = {
    2: 'Vainilla', 4: 'Fresa', 8: 'Chocolate', 16: 'Mango',
    32: 'Limón', 64: 'Uva', 128: 'Mole', 256: 'Tequila',
    512: 'Café', 1024: 'Rompope', 2048: 'Independencia',
  };

  @override
  Widget build(BuildContext context) {
    // Variable local para que Dart "sepa" que no es null dentro del widget.
    final v = valor;
    final colores = _gradientes[v] ?? [Colors.grey.shade200, Colors.grey.shade300];
    // Texto blanco solo sobre los fondos oscuros (Mole y Cafe).
    final fondoOscuro = v == 128 || v == 512;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animacion) =>
          ScaleTransition(scale: animacion, child: child),
      child: Container(
        key: ValueKey(v),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colores,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: v == null
              ? []
              : [
                  const BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: v == null
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    v.toString(),
                    style: TextStyle(
                      fontSize: v >= 128 ? 18 : 22,
                      fontWeight: FontWeight.bold,
                      color: fondoOscuro ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    _nombres[v] ?? '',
                    style: TextStyle(
                      fontSize: 10,
                      color: fondoOscuro ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
