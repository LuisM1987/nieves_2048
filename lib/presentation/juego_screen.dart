import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../logica/direccion.dart';
import '../logica/estado_juego.dart';
import '../logica/motor_juego.dart';
import 'ficha.dart';

class JuegoScreen extends StatefulWidget {
  const JuegoScreen({super.key});
  @override
  State<JuegoScreen> createState() => _JuegoScreenState();
}

class _JuegoScreenState extends State<JuegoScreen> {
  late MotorJuego _motor;

  @override
  void initState() {
    super.initState();
    _motor = MotorJuego();
  }

  // La pantalla solo traduce gestos en llamadas a mover().
  void _mover(Direccion direccion) {
    setState(() => _motor.mover(direccion));
    if (_motor.estado != EstadoJuego.jugando) _mostrarResultado();
  }

  void _mostrarResultado() {
    final gano = _motor.estado == EstadoJuego.ganado;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'resultado',
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.elasticOut),
          child: FadeTransition(
            opacity: anim1,
            child: AlertDialog(
              title: Text(gano ? '¡Independencia lograda!' : 'Se acabaron los movimientos'),
              content: Text('Puntaje final: ${_motor.puntaje}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => _motor = MotorJuego());
                  },
                  child: const Text('Jugar de nuevo'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Flechas del teclado (util para probar en web / escritorio).
  KeyEventResult _alTeclear(FocusNode nodo, KeyEvent evento) {
    if (evento is! KeyDownEvent) return KeyEventResult.ignored;
    final tecla = evento.logicalKey;
    if (tecla == LogicalKeyboardKey.arrowLeft) {
      _mover(Direccion.izquierda);
    } else if (tecla == LogicalKeyboardKey.arrowRight) {
      _mover(Direccion.derecha);
    } else if (tecla == LogicalKeyboardKey.arrowUp) {
      _mover(Direccion.arriba);
    } else if (tecla == LogicalKeyboardKey.arrowDown) {
      _mover(Direccion.abajo);
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: _alTeclear,
      child: Scaffold(
        appBar: AppBar(title: const Text('Nieves 2048 - Dolores Hidalgo')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: _motor.puntaje),
                duration: const Duration(milliseconds: 400),
                builder: (context, valor, _) => Text(
                  'Puntaje: $valor',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragEnd: (detalle) {
                  final v = detalle.primaryVelocity ?? 0;
                  if (v > 0) _mover(Direccion.derecha);
                  if (v < 0) _mover(Direccion.izquierda);
                },
                onVerticalDragEnd: (detalle) {
                  final v = detalle.primaryVelocity ?? 0;
                  if (v > 0) _mover(Direccion.abajo);
                  if (v < 0) _mover(Direccion.arriba);
                },
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: 16,
                          itemBuilder: (context, i) {
                            final valor = _motor.grid.celdas[i ~/ 4][i % 4];
                            return Ficha(valor: valor);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Desliza (o usa las flechas del teclado) para mover las nieves'),
            ),
          ],
        ),
      ),
    );
  }
}
