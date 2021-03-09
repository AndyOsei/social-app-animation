import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:interpolate/interpolate.dart';
import 'package:social_app_animation/animated_info.dart';
import 'package:social_app_animation/follow_button.dart';
import 'package:social_app_animation/models.dart';

class SocialAppDemo extends StatefulWidget {
  const SocialAppDemo({Key key}) : super(key: key);

  @override
  _SocialAppDemoState createState() => _SocialAppDemoState();
}

class _SocialAppDemoState extends State<SocialAppDemo>
    with TickerProviderStateMixin {
  PageController _pageController;
  AnimationController _infoAnimationController;
  AnimationController _snapAnimationController;
  Animation<double> _snapAnimation;
  ValueNotifier<double> _drag;
  List<Person> _people;
  int _currentPage = 0;
  double _maxHeight = 500.0;
  double _minHeight = 220.0;
  Interpolate _scaleInterpolate;
  bool _show = false;

  @override
  void initState() {
    super.initState();

    _drag = ValueNotifier<double>(_minHeight);

    _people = people();

    _pageController = PageController()
      ..addListener(() {
        final next = _pageController.page.round();
        if (_currentPage != next) {
          setState(() {
            _currentPage = next;
          });

          _infoAnimationController.forward()
            ..whenComplete(() => _infoAnimationController.reset());
        }
      });

    _infoAnimationController = AnimationController(
      duration: Duration(milliseconds: 750),
      vsync: this,
    );

    _snapAnimationController = AnimationController(
      duration: Duration(milliseconds: 750),
      vsync: this,
    )..addListener(() {
        _drag.value = _snapAnimation.value;
      });

    _scaleInterpolate = Interpolate(
      inputRange: [_minHeight, _maxHeight],
      outputRange: [1.5, 1],
      extrapolate: Extrapolate.clamp,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            physics: ClampingScrollPhysics(),
            itemCount: _people.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _drag,
                builder: (BuildContext context, Widget child) {
                  return Transform.scale(
                    alignment: Alignment.center,
                    scale: _scaleInterpolate.eval(_drag.value),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(_people[index].pic),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.25),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: _buildDetails(size),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: _buildTabBar(size),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      brightness: Brightness.dark,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.person_outlined, size: 30),
          Icon(Icons.close_outlined, size: 30),
        ],
      ),
    );
  }

  Widget _buildDetails(Size size) {
    return Container(
      height: size.height - 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedInfo(
            animation: _infoAnimationController,
            child: _buildInfoRow(),
          ),
          SizedBox(
            height: 16,
          ),
          _draggableContent(),
        ],
      ),
    );
  }

  Widget _buildDraggableContentChild() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Container(
            child: AnimatedInfo(
              animation: _infoAnimationController,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _people[_currentPage].name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _people[_currentPage].from,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  FollowButton(),
                ],
              ),
            ),
          ),
          if (_show) SizedBox(height: 30),
          if (_show)
            Text(
              '${_people[_currentPage].work}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          if (_show) SizedBox(height: 40),
          if (_show)
            Text(
              'Photos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (_show) SizedBox(height: 10),
          if (_show)
            Container(
              height: 120,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    height: 50,
                    margin: EdgeInsets.symmetric(
                        horizontal: (index == 0) ? 0.0 : 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage('assets/${index + 1}.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }

  GestureDetector _draggableContent() {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: AnimatedBuilder(
        animation: _snapAnimationController,
        child: _buildDraggableContentChild(),
        builder: (context, child) {
          return Container(
            height: _drag.value,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Color(0xFFF5F5F5),
            ),
            child: child,
          );
        },
      ),
    );
  }

  void _onPanUpdate(details) {
    final newHeight = _drag.value - details.delta.dy;
    final thresholdHeight = _maxHeight * 0.7;
    if (newHeight > thresholdHeight) {
      setState(() {
        _show = true;
      });
    } else {
      setState(() {
        _show = false;
      });
    }
    if (newHeight > _maxHeight || newHeight < _minHeight) {
      return;
    }
    setState(() {
      _drag.value -= details.delta.dy;
    });
  }

  void _onPanStart(_) {
    _snapAnimationController.stop();
  }

  void _onPanEnd(DragEndDetails details) {
    final snapEnd = _drag.value > (_maxHeight * 0.7) ? _maxHeight : _minHeight;

    _snapAnimation = _snapAnimationController.drive(
      Tween<double>(begin: _drag.value, end: snapEnd).chain(
        CurveTween(
          curve: Curves.easeOutExpo,
        ),
      ),
    );

    _snapAnimationController.reset();
    _snapAnimationController.forward();
  }

  Container _buildTabBar(Size size) {
    return Container(
      height: size.height / 8,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Colors.white,
      ),
      child: IconTheme(
        data: IconThemeData(
          color: Colors.black.withOpacity(0.5),
          size: 26,
        ),
        child: Row(
          children: [
            Expanded(
              child: Icon(
                Icons.receipt_long_outlined,
              ),
            ),
            Expanded(
              child: Icon(
                Icons.search_outlined,
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFF73828),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(247, 56, 40, 0.4),
                        blurRadius: 20,
                        offset: Offset(0.0, 10.0),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Icon(Icons.notifications_none_outlined),
            ),
            Expanded(
              child: Icon(
                Icons.chat_bubble_outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_people[_currentPage].numOfFollowers,
                style: TextStyle(color: Colors.white)),
            Text('followers', style: TextStyle(color: Colors.white)),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_people[_currentPage].numOfPosts,
                style: TextStyle(color: Colors.white)),
            Text('posts', style: TextStyle(color: Colors.white)),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _people[_currentPage].numOfFollowing,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'following',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _infoAnimationController.dispose();
    _snapAnimationController.dispose();
    _drag.dispose();
    super.dispose();
  }
}
