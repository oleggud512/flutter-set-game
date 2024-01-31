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
    begin: 1.0,
    end: 1.1,
  ).animate(CurvedAnimation(
    parent: _elevateController, 
    curve: Curves.ease
  ));

  late final AnimationController _popupController = AnimationController(
    vsync: this, 
    duration: 500.ms
  );

  late final Animation<double> _popupAnimation = Tween<double>(
    begin: 0,
    end: 1.0,
  ).animate(_popupAnimation);

  late final AnimationController _schimmerController = AnimationController(
    vsync: this, 
    duration: AppConst.incorrectSetAnimationDuration
  );

  static const _schimmerColor = {
    SetCardState.correct: Colors.green,
    SetCardState.incorrect: Colors.red,
  };

  late final flyingDuration = (AppConst.correctSetAnimationDuration.inMilliseconds - 
    _schimmerController.duration!.inMilliseconds).ms;

  late final AnimationController _flyAwayController = AnimationController(
    vsync: this, 
    duration: flyingDuration
  );

  static const _flyingRotation = -pi / 2;

  var _isHidden = false;

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
      .translate(-currentSize.width / 2, currentSize.width + 20);

    final xAxisAnimation = Tween<double>(
      begin: currentPosition.dx,
      end: endPosition.dx,
    ).animate(_flyAwayController);

    final yAxisAnimation = Tween<double>(
      begin: currentPosition.dy,
      end: endPosition.dy
    ).chain(CurveTween(
      curve: const ParabolicCurve()
    )).animate(_flyAwayController);

    final rotationAnimation = Tween<double>(
      begin: 0,
      end: _flyingRotation
    ).animate(_flyAwayController);

    final entry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: _flyAwayController, 
          builder: (context, child) {
            return Positioned(
              top: yAxisAnimation.value,
              left: xAxisAnimation.value,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateZ(rotationAnimation.value),
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
        _isHidden = true;
      });
    });

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isHidden ? 0 : 1,
      child: GestureDetector(
        onTap: () {
          elevate();
          widget.onPressed.call();
        },
        child: ScaleTransition(
          scale: _popupController,
          child: AnimatedBuilder(
            animation: _elevateController,
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
                  child: child!,
                ),
              );
            },
            child: AnimatedSchimmer(
              animation: _schimmerController,
              schimmerWidth: p32,
              borderRadius: AppConst.cardBorderRadius,
              color: _schimmerColor[widget.cardState] ?? Colors.transparent,
              child: SetCardWidgetContent(
                card: widget.card, 
                cardState: widget.cardState
              )
            )
          ),
        )
      ),
    );
  }

  Widget buildElevated({required Widget child}) {
    return Transform.scale(
      scale: _elevateAnimation.value,
      child: child
    );
  }

}