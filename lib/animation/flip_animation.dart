import 'dart:math';

import 'package:flutter/material.dart';

class FlipAnimation extends StatefulWidget {
  const FlipAnimation(
      {required this.word,
      required this.animate,
      required this.reverse,
      required this.animationCompleted,
      this.delay = 0,
      Key? key})
      : super(key: key);

  final Widget word;
  final bool animate;
  final bool reverse;
  final Function(bool) animationCompleted;
  final int delay;

  @override
  State<FlipAnimation> createState() => _FlipAnimationState();
}

class _FlipAnimationState extends State<FlipAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.animationCompleted.call(true);
        }
        if (status == AnimationStatus.dismissed) {
          widget.animationCompleted.call(false);
        }
      });

    // _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
    //     CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),);
  }

  // @override
  // void didUpdateWidget(covariant FlipAnimation oldWidget) {
  //   Future.delayed(Duration(milliseconds: widget.delay), () {
  //     if (mounted) {
  //       if (widget.animate) {
  //         if (widget.reverse) {
  //           _controller.reverse();
  //         } else {
  //           _controller.reset();
  //           _controller.forward();
  //         }
  //       }
  //     }
  //   });

  //   super.didUpdateWidget(oldWidget);
  // }
    // @override
  // void didUpdateWidget(covariant FlipAnimation oldWidget) {
  //   if (widget.animate != oldWidget.animate || widget.reverse != oldWidget.reverse) {
  //     Future.delayed(Duration(milliseconds: widget.delay), () {
  //       if (mounted) {
  //         if (widget.animate) {
  //           if (widget.reverse) {
  //             _controller.reverse();
  //           } else {
  //             _controller.forward();
  //           }
  //         }
  //       }
  //     });
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }
@override
void didUpdateWidget(covariant FlipAnimation oldWidget) {
  if (widget.animate != oldWidget.animate || widget.reverse != oldWidget.reverse) {
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted && widget.animate) {
        // ตรวจสอบสถานะก่อนเริ่ม Animation
        if (widget.reverse) {
          if (_controller.status != AnimationStatus.dismissed) {
            _controller.reverse();
          }
        } else {
          if (_controller.status != AnimationStatus.completed) {
            _controller.forward();
          }
        }
      }
    });
  }
  super.didUpdateWidget(oldWidget);
}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..rotateY(_animation.value * pi)
          ..setEntry(3, 2, 0.005),
        child: _controller.value >= 0.50
            ? widget.word
            : Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Icon(
                Icons.help_outline,
                size: 40,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
      ),
    );
  }
}
