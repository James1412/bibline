import 'dart:math';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;
  late final _position = AnimationController.unbounded(
      vsync: this, duration: const Duration(seconds: 1));

  late final Tween<double> _rotation = Tween(begin: -15, end: 15);

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = (size.width - 200);
    final dropZone = size.width + 100;

    if (_position.value.abs() >= bound) {
      if (_position.value.isNegative) {
        _position.animateTo(dropZone * -1);
      } else {
        _position.animateTo(dropZone);
      }
    } else {
      _position.animateTo(0, curve: Curves.bounceOut);
    }
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onHorizontalDragEnd: _onHorizontalDragEnd,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _position,
          builder: (context, child) {
            final angle = _rotation.transform(
                    (_position.value + size.width / 2) / size.width) *
                pi /
                180;
            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 200,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      angle: angle,
                      child: Material(
                        elevation: 10,
                        color: Colors.red.shade100,
                        child: SizedBox(
                          width: size.width * 0.8,
                          height: size.height * 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
