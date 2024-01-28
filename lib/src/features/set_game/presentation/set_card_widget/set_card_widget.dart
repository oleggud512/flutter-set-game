import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:set_game/src/core/common/constants/sizes.dart';
import 'package:set_game/src/core/common/logger.dart';
import 'package:set_game/src/core/external/inject.dart';
import 'package:set_game/src/features/set_game/application/use_cases/choose_card_use_case.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card_state.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

part 'set_card_widget_content.dart';

class SetCardWidget extends StatefulWidget {
  const SetCardWidget({
    super.key,
    required this.card,
    required this.cardState,
    this.onPressed
  });

  final SetCard card;
  final SetCardState cardState;
  final VoidCallback? onPressed;

  @override
  State<SetCardWidget> createState() => _SetCardWidgetState();
}

class _SetCardWidgetState extends State<SetCardWidget> with TickerProviderStateMixin {
  final flyingDuration = const Duration(milliseconds: 1200);

  late final AnimationController _elevateController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200)
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
    duration: const Duration(milliseconds: 300)
  );

  bool isShown = true;

  bool isElevated = false;

  Future<void> elevate() async {
    await _elevateController.forward();
    isElevated = true;
  }

  Future<void> lower() async {
    await _elevateController.reverse(from: 1);
    isElevated = false;
  }

  Future<void> popup() async {
    _elevateController.reset();
    _popupController.reset();
    // Keep card hidden for a while
    return Future.delayed(const Duration(milliseconds: 300), _popupController.forward);
    // return _popupController.forward();
  }

  @override
  void initState() { 
    super.initState();
    popup();
  }

  @override
  void didUpdateWidget(covariant SetCardWidget oldWidget) {
    print("updated: ${widget.card}");
    final cur = widget.cardState;
    final old = oldWidget.cardState;
    
    if (cur == SetCardState.available && old == SetCardState.available) {
      _elevateController.reset();
    }

    // if (cur == SetCardState.available && old == SetCardState.choosen) {
    //   we don't handle this case, because it's controlled by onTap callback
    // }

    if (cur == SetCardState.available && old == SetCardState.incorrect) {
      lower();
    }
    
    if (cur == SetCardState.available && old == SetCardState.correct) {
      popup();
      setState(() {
        isShown = true;
      });
    }
    
    if (cur == SetCardState.correct) {
      final box = context.findRenderObject() as RenderBox;
      final currentPosition = box.localToGlobal(Offset.zero);
      final currentSize = box.size;
      final endPosition = MediaQuery.of(context).size.bottomCenter(Offset.zero).translate(-currentSize.width / 2, 0);
      
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          isShown = false;
        });
        final entry = OverlayEntry(
          builder: (context) {
            return TweenAnimationBuilder(
              tween: Tween<Offset>(
                begin: currentPosition,
                end: endPosition,
              ), 
              duration: flyingDuration, 
              builder: (context, value, child) {
                return Positioned(
                  left: value.dx,
                  top: value.dy,
                  child: SizedBox(
                    height: currentSize.height,
                    width: currentSize.width,
                    child: child
                  )
                );
              },
              child: buildElevated(_SetCardWidgetContent(
                card: widget.card, 
                cardState: SetCardState.choosen
              ))
            );
          }
        );

        Overlay.of(context).insert(entry);
        Future.delayed(flyingDuration, entry.remove);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _elevateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.cardState == SetCardState.available) {
          await elevate();
        } else {
          await lower();
        }
        widget.onPressed?.call();
      },
      child: Opacity(
        opacity: isShown ? 1 : 0,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _elevateController, 
            _popupController
          ]),
          builder: (context, child) {
            return ScaleTransition(
              scale: _popupController,
              child: buildElevated(child!)
            );
          },
          child: buildContent(context)
        ),
      ),
    );
  }

  Transform buildElevated(Widget child) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..translate(Vector3(0, 0, -_elevateAnimation.value)),
      child: buildContent(context)
    );
  }

  Widget buildContent(BuildContext context) {
    return _SetCardWidgetContent(
      card: widget.card, 
      cardState: widget.cardState,
    );
  }
}