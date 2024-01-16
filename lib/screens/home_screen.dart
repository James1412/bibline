import 'dart:math';

import 'package:flutter/material.dart';

enum ActiveButton {
  close,
  check,
  none,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;

  ActiveButton _active = ActiveButton.none;

  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
    lowerBound: (size.width + 100) * -1,
    upperBound: (size.width + 100),
    value: 0.0,
  );

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1,
  );

  late final ColorTween _colorClose = ColorTween(
    begin: Colors.white,
    end: Colors.red,
  );

  late final ColorTween _colorCheck = ColorTween(
    begin: Colors.white,
    end: Colors.green,
  );

  late final ColorTween _fontColorClose = ColorTween(
    begin: Colors.red,
    end: Colors.white,
  );

  late final ColorTween _fontColorCheck = ColorTween(
    begin: Colors.green,
    end: Colors.white,
  );

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;

    if (_position.value.isNegative && _active != ActiveButton.close) {
      setState(() {
        _active = ActiveButton.close;
      });
    }

    if (_position.value > 0 && _active != ActiveButton.check) {
      setState(() {
        _active = ActiveButton.check;
      });
    }
  }

  void _whenComplete() {
    _position.value = 0;
    setState(() {
      _index = _index == 5 ? 1 : _index + 1;
      _active = ActiveButton.none;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 200;
    final dropZone = size.width + 100;
    if (_position.value.abs() >= bound) {
      if (_position.value.isNegative) {
        _position.animateTo((dropZone) * -1).whenComplete(_whenComplete);
      } else {
        _position.animateTo(dropZone).whenComplete(_whenComplete);
      }
    } else {
      _position.animateTo(
        0,
        curve: Curves.elasticOut,
      );
    }
  }

  void _onTapClose() {
    _position
        .animateTo(
          (size.width + 100) * -1,
          curve: Curves.easeOut,
        )
        .whenComplete(_whenComplete);
    setState(() {
      _active = ActiveButton.close;
    });
  }

  void _onTapCheck() {
    _position
        .animateTo(
          (size.width + 100),
          curve: Curves.easeOut,
        )
        .whenComplete(_whenComplete);
    setState(() {
      _active = ActiveButton.check;
    });
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle = _rotation.transform(
                (_position.value + size.width / 2) / size.width,
              ) *
              pi /
              180;
          final position = _position.value.abs() / size.width;
          final scale = _scale.transform(position);
          final colorClose = _colorClose.transform(position);
          final colorCheck = _colorCheck.transform(position);
          final fontColorClose = _fontColorClose.transform(position);
          final fontColorCheck = _fontColorCheck.transform(position);

          return Column(
            children: [
              Flexible(
                flex: 4,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: 150,
                      child: Transform.scale(
                        scale: scale,
                        child: Card(index: _index == 5 ? 1 : _index + 1),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      child: GestureDetector(
                        onHorizontalDragUpdate: _onHorizontalDragUpdate,
                        onHorizontalDragEnd: _onHorizontalDragEnd,
                        child: Transform.translate(
                          offset: Offset(_position.value, 0),
                          child: Transform.rotate(
                            angle: angle,
                            child: Card(index: _index),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: _active == ActiveButton.close ? scale + 0.2 : 1,
                      child: GestureDetector(
                        onTap: _onTapClose,
                        child: Material(
                          elevation: 10,
                          shape: const CircleBorder(),
                          color: _active == ActiveButton.close
                              ? colorClose
                              : Colors.white,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            width: 80,
                            height: 80,
                            child: Icon(Icons.close,
                                color: _active == ActiveButton.close
                                    ? fontColorClose
                                    : Colors.red),
                          ),
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: _active == ActiveButton.check ? scale + 0.2 : 1,
                      child: GestureDetector(
                        onTap: _onTapCheck,
                        child: Material(
                          elevation: 10,
                          shape: const CircleBorder(),
                          color: _active == ActiveButton.check
                              ? colorCheck
                              : Colors.white,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            width: 80,
                            height: 80,
                            child: Icon(
                              Icons.check,
                              color: _active == ActiveButton.check
                                  ? fontColorCheck
                                  : Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Card extends StatelessWidget {
  final int index;

  const Card({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width * 0.85,
        height: size.height * 0.55,
        child: Image.asset(
          "assets/covers/$index.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
