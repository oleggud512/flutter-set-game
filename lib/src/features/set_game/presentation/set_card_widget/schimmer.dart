import 'package:flutter/material.dart';
import 'package:set_game/src/core/common/constants/sizes.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

class Schimmer extends StatelessWidget {
  Schimmer({
    super.key, 
    required this.child, 
    required this.offset, 
    this.color = Colors.amber,
    this.borderRadius,
    this.schimmerWidth = p16,
  }) : assert(offset >= 0.0 && offset <= 1.0);

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
                    ..rotateZ(radians(15)),
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