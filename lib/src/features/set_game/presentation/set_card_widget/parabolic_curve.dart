import 'dart:math';

import 'package:flutter/material.dart';

class ParabolicCurve extends Curve {
  const ParabolicCurve([this.depth = 3]);

  final double depth;

  @override
  double transformInternal(double t) {
    return depth * pow(t, 2) + (1 - depth) * t;
  }
}