import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:set_game/src/core/common/constants/sizes.dart';

class AnimatedSchimmer extends StatefulWidget {
  const AnimatedSchimmer({
    super.key, 
    required this.animation,
    required this.child,
    this.schimmerWidth = p16,
    this.color = Colors.amber,
    this.borderRadius = BorderRadius.zero,
  });

  /// 0.0 - 1.0
  final Animation<double> animation;
  final double schimmerWidth;
  final Widget child;
  final Color color;
  final BorderRadius borderRadius;

  @override
  State<AnimatedSchimmer> createState() => _AnimatedSchimmerState();
}

class _AnimatedSchimmerState extends State<AnimatedSchimmer> {

  late final schimmerFullWidth = widget.schimmerWidth * 3;
  
  static const _tilt = pi / 12;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: widget.animation,
            builder: (context, child) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  child!,
                  Positioned(
                    top: -widget.schimmerWidth,
                    left: (constraints.maxWidth + schimmerFullWidth + 12) * widget.animation.value + widget.schimmerWidth - (schimmerFullWidth + 12),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..rotateZ(_tilt),
                      child: Container(
                        width: widget.schimmerWidth,
                        height: constraints.maxHeight + widget.schimmerWidth * 2,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: widget.color,
                              blurRadius: widget.schimmerWidth
                            ),
                          ]
                        )
                      ),
                    ),
                  ),
                ],
              );
            },
            child: widget.child,
          );
        }
      ),
    );
  }
}

class Schimmer extends StatelessWidget {
  Schimmer({
    super.key, 
    required this.child, 
    required this.offset, 
    this.color = Colors.amber,
    this.borderRadius,
    this.schimmerWidth = p16,
  }) : assert(offset >= 0.0 && offset <= 1.0);

  static const _tilt = pi / 12;

  final Widget child;
  final double offset;
  final Color color;
  final BorderRadius? borderRadius;

  final double schimmerWidth;
  late final double schimmerFullWidth = schimmerWidth * 3;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: Stack(
            fit: StackFit.expand,
            children: [
              child,
              Positioned(
                top: -schimmerWidth,
                left: (constraints.maxWidth + schimmerFullWidth + 12) * offset + schimmerWidth - (schimmerFullWidth + 12),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateZ(_tilt),
                  child: Container(
                    width: schimmerWidth,
                    height: constraints.maxHeight + schimmerWidth * 2,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: color,
                          blurRadius: schimmerWidth
                        ),
                      ]
                    )
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}