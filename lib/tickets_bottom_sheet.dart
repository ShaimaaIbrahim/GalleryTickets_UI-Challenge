import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:gallery_tickets/event_class.dart';

const double minHeight = 120;

class TicketsBottomSheet extends StatefulWidget {
  const TicketsBottomSheet({Key? key}) : super(key: key);

  @override
  _TicketsBottomSheetState createState() => _TicketsBottomSheetState();
}

class _TicketsBottomSheetState extends State<TicketsBottomSheet>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  late double maxHeight;

  double? get headerFontSize => lerp(14, 24);

  double? get headerTopMargin =>
      lerp(20, 20 + MediaQuery.of(context).padding.top);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  Widget build(BuildContext context) {
    maxHeight = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
        animation: _controller!,
        builder: (context, child) {
          return Positioned(
              height: lerp(minHeight, maxHeight),
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                  onTap: _toggle,
                  onVerticalDragUpdate: _handleDragUpdate,
                  onVerticalDragEnd: _handleDragEnd,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    decoration: const BoxDecoration(
                      color: Color(0xFF162A49),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    child: Stack(
                      children: [
                        MenuButton(),
                        TextHeader(
                            topMargin: headerTopMargin!,
                            fontSize: headerFontSize!),
                      ],
                    ),
                  )));
        });
  }

  void _toggle() {
    var isOpen = _controller!.status == AnimationStatus.completed;
    _controller!.fling(velocity: isOpen ? -2.0 : 2.0);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller!.value -= details.primaryDelta! / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller!.isAnimating ||
        _controller!.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;

    if (flingVelocity < 0.0) {
      _controller!.fling(velocity: math.max(2.0, -flingVelocity));
    } else if (flingVelocity > 0.0) {
      _controller!.fling(velocity: math.max(-2.0, -flingVelocity));
    } else {
      _controller!.fling(velocity: _controller!.value < 0.5 ? -2.0 : 2.0);
    }
  }

  double? lerp(double min, double max) =>
      lerpDouble(min, max, _controller!.value);
}

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 24,
      child: Icon(
        Icons.menu,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}

class TextHeader extends StatelessWidget {
  final double topMargin;
  final double fontSize;

  TextHeader({required this.topMargin, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      child: Text(
        'Ticket Exhiptions',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/*Widget _buildIcon(Event event) {
  return Positioned();
}*/

final List<Event> events = [
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('rodion-kutsaev.jpeg', 'Dawan District Guangdong Hong Kong', '4.28-31'),
];
