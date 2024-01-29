import 'dart:async';
import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:set_game/src/core/common/constants/app_constants.dart';
import 'package:set_game/src/core/common/constants/sizes.dart';
import 'package:set_game/src/core/common/extensions/int.dart';
import 'package:set_game/src/core/common/logger.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card_state.dart';
import 'package:set_game/src/features/set_game/presentation/set_card_widget/schimmer.dart';
import 'package:set_game/src/features/set_game/presentation/set_card_widget/set_card_widget_content.dart';
import 'package:set_game/src/features/set_game/presentation/set_card_widget/parabolic_curve.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3, radians;

class SetCardWidget extends StatefulWidget {
  const SetCardWidget({
    super.key,
    required this.card,
    required this.cardState,
    required this.onPressed,
  });

  final SetCard card;
  final SetCardState cardState;
  final VoidCallback onPressed;

  @override
  State<SetCardWidget> createState() => _SetCardWidgetState();
}

class _SetCardWidgetState extends State<SetCardWidget> with TickerProviderStateMixin {

  late final AnimationController _elevateController = AnimationController(
    vsync: this, 
    duration: AppConst.elevateCardAnimatinoDuration
  );
  late final Animation<double> _elevateAnimation = Tween<double>(
    begin: 0.0,
    end: 100.0,
  ).animate(CurvedAnimation(
    parent: _elevateController, 
    curve: Curves.ease
  ));

  late final AnimationController _popupController = AnimationController(
    vsync: this, 
    duration: 500.ms
  );

  late final AnimationController _schimmerController = AnimationController(
    vsync: this, 
    duration: AppConst.incorrectSetAnimationDuration
  );

  late final flyingDuration = (AppConst.correctSetAnimationDuration.inMilliseconds - 
    _schimmerController.duration!.inMilliseconds).ms;

  late final AnimationController _flyAwayController = AnimationController(
    vsync: this, 
    duration: flyingDuration
  );

  Color get schimmerColor => switch (widget.cardState) {
    SetCardState.correct => Colors.green,
    SetCardState.incorrect => Colors.red,
    _ => Colors.transparent,
  };

  var isHidden = false;

  @override
  void initState() { 
    super.initState();
    _popupController.forward();
  }

  @override
  void dispose() {
    _elevateController.dispose();
    _popupController.dispose();
    _schimmerController.dispose();
    _flyAwayController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SetCardWidget oldWidget) {
    if (widget.cardState == SetCardState.incorrect) {
      schimmer();
    }

    if (widget.cardState == SetCardState.correct) {
      schimmer()
        .then((_) => flyAway());
    }

    if (oldWidget.cardState == SetCardState.incorrect || 
      widget.cardState == SetCardState.available && 
        oldWidget.cardState == SetCardState.choosen
    ) {
      lower();
    }

    super.didUpdateWidget(oldWidget);
  }

  Future<void> elevate() {
    return _elevateController.forward();
  }

  Future<void> lower() {
    return _elevateController.reverse(from: 1);
  }

  Future<void> schimmer() {
    return _schimmerController.forward()
      .then((_) => _schimmerController.reset());
  }

  Future<void> flyAway() {
    final box = context.findRenderObject() as RenderBox;
    final currentPosition = box.localToGlobal(Offset.zero);
    final currentSize = box.size;
    final endPosition = MediaQuery.of(context).size
      .bottomCenter(Offset.zero)
      .translate(-currentSize.width / 2, currentSize.height + 20);

    final xAxisTween = Tween<double>(
      begin: currentPosition.dx,
      end: endPosition.dx,
    );

    final yAxisTween = Tween<double>(
      begin: currentPosition.dy,
      end: endPosition.dy
    ).chain(CurveTween(
      curve: const ParabolicCurve()
    ));

    final rotationTween = Tween<double>(
      begin: 0,
      end: -radians(95)
    );

    final entry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: _flyAwayController, 
          builder: (context, child) {
            final x = xAxisTween.evaluate(_flyAwayController);
            final y = yAxisTween.evaluate(_flyAwayController);
            return Positioned(
              top: y,
              left: x,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateZ(rotationTween.evaluate(_flyAwayController)),
                child: child!,
              ),
            );
          },
          child: buildElevated(
            child: SizedBox(
              height: currentSize.height,
              width: currentSize.width,
              child: SetCardWidgetContent(
                card: widget.card, 
                cardState: widget.cardState
              ),
            )
          )
        );
      }
    );
    
    final completer = Completer();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _flyAwayController.forward();
      Future.delayed(_flyAwayController.duration!, () {
        entry.remove();
        completer.complete();
      });
      Overlay.of(context).insert(entry);

      setState(() {
        isHidden = true;
      });
    });

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isHidden ? 0 : 1,
      child: GestureDetector(
        onTap: () {
          elevate();
          widget.onPressed.call();
        },
        child: ScaleTransition(
          scale: _popupController,
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _elevateController,
              _schimmerController
            ]),
            builder: (context, child) {
              return buildElevated(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: AppConst.cardBorderRadius,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4 * _elevateController.value,
                      )
                    ]
                  ),
                  child: Schimmer(
                    schimmerWidth: p32,
                    borderRadius: AppConst.cardBorderRadius,
                    offset: _schimmerController.value,
                    color: schimmerColor,
                    child: child!
                  ),
                ),
              );
            },
            child: SetCardWidgetContent(
              card: widget.card, 
              cardState: widget.cardState
            )
          ),
        )
      ),
    );
  }

  Widget buildElevated({required Widget child}) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..translate(Vector3(0, 0, -_elevateAnimation.value)),
      child: child,
    );
  }

}