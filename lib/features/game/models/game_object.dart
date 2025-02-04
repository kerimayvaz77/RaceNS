import 'package:flutter/material.dart';

abstract class GameObject {
  Offset position;

  GameObject({
    required this.position,
  });

  void update();
  void render(Canvas canvas, Size size);
}
