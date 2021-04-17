library animated_expolde_button;

import 'dart:math';

import 'package:flutter/material.dart';

typedef OnTap();

class AnimatedExplodeButton extends StatefulWidget {
  final OnTap onTap;
  final Widget child;
  final Color color;

  @override
  final Key key;
  AnimatedExplodeButton({this.onTap, this.color, @required this.child, this.key})
      : assert(child != null),
        super(key: key);
  @override
  _AnimatedExplodeButtonState createState() => _AnimatedExplodeButtonState();
}

class _AnimatedExplodeButtonState extends State<AnimatedExplodeButton> with SingleTickerProviderStateMixin {
  List<Widget> particles;
  AnimationController controller;
  Random source = Random();
  BoxConstraints constraints;
  GlobalKey widgetKey;
  @override
  void initState() {
    super.initState();
    widgetKey = GlobalKey();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    particles = [];
    controller.addListener(() {
      if (controller.isCompleted) {
        controller.reset();
        setState(() {
          particles = [];
        });
      }
    });
  }




  @override
  void dispose() {
    controller.removeListener(() {});
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        GestureDetector(
            onTapDown: (tapDetails) {
              final RenderBox renderBoxRed = widgetKey.currentContext.findRenderObject();
              final size = renderBoxRed.size;
              if (widget.onTap != null) {
                widget.onTap();
              }
              controller.reset();
              controller.forward();
              setState(() {
                particles = List.generate(
                    50,
                        (index) => new Particle(
                      key: GlobalKey(),
                      color: widget.color,
                      offset: Offset(tapDetails.localPosition.dx - size.width/2,tapDetails.localPosition.dy - size.height/2),
                      controller: controller,
                      maxSize: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height),
                    ));
              });
            },
            child:
            Padding(key:widgetKey,child:widget.child, padding: EdgeInsets.all(10)))
      ] +
          particles,
    );
  }
}

class Particle extends StatefulWidget {
  final Offset offset;
  final AnimationController controller;
  final String no;
  final Size maxSize;
  final Color color;
  Particle({this.offset, this.controller, this.no, this.maxSize,@required this.color = Colors.yellow,Key key}) : super(key: key);
  @override
  _ParticleState createState() => _ParticleState();
}

class _ParticleState extends State<Particle>
    with SingleTickerProviderStateMixin {
  double size;
  double speed;
  double angle;
  Random source;
  AnimationController controller;
  Animation animation;
  double acc = 1000.0;
  Color color;
  Size maxSize;
  double doubleInRange(double start, double end) =>
      source.nextDouble() * (end - start) + start;
  @override
  void initState() {
    super.initState();
    source = Random();
    animation = Tween(begin: 0.0, end: 4.0).animate(widget.controller);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    color = widget.color.withOpacity(doubleInRange(0.3, 1));
    size = doubleInRange(10, 25);
    angle = doubleInRange(0, 2 * pi);
    speed = doubleInRange(200, 400);
    maxSize = widget.maxSize;
  }

  Offset calculateOffset({double time}) {
    var x = widget.offset.dx + speed * cos(angle) * time;
    var y = widget.offset.dy +
        (speed * sin(angle) * time + 0.5 * acc * time * time);

    if (x > maxSize.width) {
      x = maxSize.width;
    }
    if (x < -maxSize.width) {
      x = -maxSize.width;
    }
    if (y > maxSize.height) {
      y = maxSize.height;
    }
    if (y < -maxSize.height) {
      y = -maxSize.height;
    }

    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: calculateOffset(time: animation.value),
          child: Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        );
      },
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

