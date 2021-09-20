import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:gallery_tickets/event_class.dart';

const double minHeight = 120;
const double iconStartSize = 44;
const double iconEndSize = 120;
const double iconStartMarginTop = 36;
const double iconEndMarginTop = 80;
const double iconsVerticalSpacing = 24;
const double iconsHorizontalSpacing = 16;

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

  double? get iconSize => lerp(iconStartSize, iconEndSize);

  double? get itemBorderRadius => lerp(8, 24);

  double? get iconLeftBorderRadius => itemBorderRadius;

  double? get iconRightBorderRadius => lerp(8, 0);

  double? iconTopMargin(int index) =>
      lerp(iconStartMarginTop,
          iconEndMarginTop + index * (iconsVerticalSpacing + iconEndSize))! +
      headerTopMargin!;

  double? iconLeftMargin(int index) =>
      lerp(index * (iconsHorizontalSpacing + iconStartSize), 0);

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
                        for (Event event in events) _buildFullItem(event),
                        for (Event event in events) _buildIcon(event),
                      ],
                    ),
                  )));
        });
  }

  double? lerp(double min, double max) =>
      lerpDouble(min, max, _controller!.value);

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

  Widget _buildIcon(Event event) {
    int index = events.indexOf(event);
    return Positioned(
      height: iconSize!,
      width: iconSize!,
      top: iconTopMargin(index),
      left: iconLeftMargin(index),
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(iconLeftBorderRadius!),
          right: Radius.circular(iconRightBorderRadius!),
        ),
        child: Image.asset(
          'assets/${event.assetName}',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildFullItem(Event event) {
    int index = events.indexOf(event);
    return ExpandedEventItem(
      topMargin: iconTopMargin(index)!,
      leftMargin: iconLeftMargin(index)!,
      height: iconSize!,
      isVisible: _controller!.status == AnimationStatus.completed,
      borderRadius: itemBorderRadius!,
      title: event.title,
      date: event.date,
    );
  }
}

class ExpandedEventItem extends StatelessWidget {
  final double topMargin;
  final double leftMargin;
  final double height;
  final bool isVisible;
  final double borderRadius;
  final String title;
  final String date;

  const ExpandedEventItem(
      {Key? key,
      required this.topMargin,
      required this.height,
      required this.isVisible,
      required this.borderRadius,
      required this.title,
      required this.date,
      required this.leftMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      left: leftMargin,
      right: 0,
      height: height,
      child: AnimatedOpacity(
        opacity: isVisible ? 1 : 0,
        duration: Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(left: height).add(EdgeInsets.all(8)),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: <Widget>[
        Text(title, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Row(
          children: <Widget>[
            Text(
              '1 ticket',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(width: 8),
            Text(
              date,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Spacer(),
        Row(
          children: <Widget>[
            Icon(Icons.place, color: Colors.grey.shade400, size: 16),
            Text(
              'Science Park 10 25A',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            )
          ],
        )
      ],
    );
  }
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

final List<Event> events = [
  Event('hyper.png', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('hyper.png', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('hyper.png', 'Dawan District Guangdong Hong Kong', '4.28-31'),
];
