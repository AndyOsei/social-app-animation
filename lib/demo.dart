import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
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
  List<Person> _people;
  int _currentPage = 0;
  double _drag = 0.0;
  double _maxHeight = 500.0;
  double _minHeight = 240.0;

  @override
  void initState() {
    super.initState();

    _drag = 240;

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
        _drag = _snapAnimation.value;
      });
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
            itemCount: _people.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_people[index].pic),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2),
                      BlendMode.darken,
                    ),
                  ),
                ),
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
        children: [
          Spacer(flex: 1),
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
          Spacer(flex: 3),
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
            height: _drag,
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
    final newHeight = _drag - details.delta.dy;
    if (newHeight > _maxHeight || newHeight < _minHeight) {
      return;
    }
    setState(() {
      _drag -= details.delta.dy;
    });
  }

  void _onPanStart(_) {
    _snapAnimationController.stop();
  }

  void _onPanEnd(DragEndDetails details) {
    final end = _drag > (_maxHeight * 0.7) ? _maxHeight : _minHeight;
    _snapAnimation = _snapAnimationController.drive(
      Tween<double>(begin: _drag, end: end).chain(
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
    super.dispose();
  }
}
