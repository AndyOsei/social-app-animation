import 'package:flutter/material.dart';

class FollowButton extends StatefulWidget {
  const FollowButton({
    Key key,
  }) : super(key: key);

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _width;
  Animation<double> _iconOpacity;
  Animation<double> _textOpacity;
  bool _follow = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    _textOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.010, curve: Curves.ease),
      ),
    );

    _width = Tween<double>(begin: 120.0, end: 40.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.010, 0.600, curve: Curves.easeIn),
        reverseCurve: Curves.easeOut,
      ),
    );

    _iconOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.700, 1.000, curve: Curves.ease),
      ),
    );
  }

  Container _buildAnimation(
    BuildContext context,
    Widget child,
  ) {
    return Container(
      width: _width.value,
      height: 40,
      decoration: BoxDecoration(
        color: _follow ? Color(0xFFF73828) : Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Color(0xFFF73828)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: _textOpacity.value,
            child: Text(
              'FOLLOW',
              style: TextStyle(
                color: Color(0xFFF73828),
              ),
            ),
          ),
          Opacity(
            opacity: _iconOpacity.value,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Icon(
                Icons.person_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onTap() {
    setState(() {
      _follow = !_follow;
    });
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: _buildAnimation,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
