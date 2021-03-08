import 'package:flutter/material.dart';

class DraggableSheet extends StatefulWidget {
  final double minChildSize;

  final double maxChildSize;

  final Widget child;

  DraggableSheet({
    Key key,
    this.minChildSize = 0.4,
    this.maxChildSize = 1.0,
    @required this.child,
  }) : super(key: key);

  @override
  _DraggableSheetState createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<DraggableSheet>
    with SingleTickerProviderStateMixin {
  double _drag;

  double _maxHeight = 0.0;

  double _minHeight = 0.0;

  AnimationController _controller;

  Animation<double> _snap;

  BoxConstraints _currentConstraints;

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
      duration: Duration(milliseconds: 750),
      vsync: this,
    )..addListener(() {
        _drag = _snap.value;
      });
  }

  void _setHeights(BoxConstraints constraints) {
    _minHeight = constraints.maxHeight * widget.minChildSize;
    _maxHeight = constraints.maxHeight * widget.maxChildSize;

    if (_drag == null) {
      _drag = _minHeight;
    }
  }

  double _getSheetHeight(bool isAbove) {
    double fitHeight;

    if (isAbove) {
      fitHeight = _currentConstraints.maxHeight - _drag - 75;
    } else {
      fitHeight = _drag;
    }

    return fitHeight;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        _currentConstraints = constraints;
        _setHeights(constraints);

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: widget.child,
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: _drag,
              height: 10,
              child: _detectGesture(Container(color: Colors.blue)),
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: _drag + 75,
              height: _getSheetHeight(true),
              // child: Container(color: Color(0xFFF5F5F5)),
              child: Container(),
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              top: constraints.maxHeight - _drag,
              height: _getSheetHeight(false),
              child: Container(),
            ),
          ],
        );
      },
    );
  }

  Widget _detectGesture(Widget child) {
    return GestureDetector(
      onPanStart: (_) {
        // _controller.stop();
      },
      onPanUpdate: (details) {
        final newHeight = _drag - details.delta.dy;
        if (newHeight > _maxHeight || newHeight < _minHeight) {
          return;
        }
        setState(() {
          _drag -= details.delta.dy;
        });
      },
      onPanEnd: (_) {
        // final end = _drag > (_maxHeight / 2) ? _maxHeight : _minHeight;
        // _snap = _controller.drive(
        //   Tween<double>(begin: _drag, end: end).chain(
        //     CurveTween(
        //       curve: Curves.easeOutExpo,
        //     ),
        //   ),
        // );

        // _controller.reset();
        // _controller.forward();
      },
      child: child,
    );
  }
}
