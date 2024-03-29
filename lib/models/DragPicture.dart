import "package:flutter/material.dart";
import 'FormationPosition.dart';

import 'dart:math' as math;

class DragPicture extends StatefulWidget {
  final Offset initialOffset;
  final String text;

  const DragPicture(this.text, this.initialOffset, {Key? key}) : super(key: key);

  @override
  _DragPictureState createState() => _DragPictureState();
}

class _DragPictureState extends State<DragPicture> {
  Offset position = const Offset(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    position = widget.initialOffset;
  }

  @override
  Widget build(BuildContext context) {
    final item = Container(
      width: 50.0,
      height: 50.0,
      color: Colors.pink,
      child: Center(
        child: Text(
          widget.text,
          style: const TextStyle(color: Colors.white, fontSize: 22.0),
        ),
      ),
    );
    final avatar = Container(
      width: 50.0,
      height: 50.0,
      color: Colors.pink.withOpacity(0.4),
      child: Center(
        child: Text(
          widget.text,
          style: const TextStyle(color: Colors.white, fontSize: 22.0),
        ),
      ),
    );
    final draggabel = Draggable(
      data: widget.text,
      feedback: avatar,
      childWhenDragging: Opacity(opacity: 0.0, child: item),
      onDraggableCanceled: (velocity, offset) {
        print('DragBoxState.build -> offset ($offset)');
        setState(() {
          position = offset;
        });
      },
      child: item,
    );
    return Positioned(
        left: position.dx, top: position.dy, child: draggabel);
  }
}

class DragRoundPicture extends StatefulWidget {
  const DragRoundPicture(
      {Key? key, this.image, this.size, this.child, this.tappable = false})
      : super(key: key);

  final String? image;
  final double? size;
  final Widget? child;
  final bool? tappable;

  @override
  DragRoundPictureState createState() => DragRoundPictureState();
}

const allowedUsers = [
  "tSFXWNgYNRhzFKXKw3xvaEhCsUB2",
  "q34qmsOSzWWR30I06omGJ3ti0142",
  "v8qunIYGqhNnGPUdykHqFs2ABYW2"
];

class DragRoundPictureState extends State<DragRoundPicture> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage("assets${widget.image}"),
                fit: BoxFit.cover),
            border: Border.all(width: 2.0),
            shape: BoxShape.circle),
        child: widget.child,
      ),
    );
  }
}

class DashOutlineCirclePainter extends CustomPainter {
  const DashOutlineCirclePainter();

  static const int segments = 17;
  static const double deltaTheta = math.pi * 2 / segments; // radians
  static const double segmentArc = deltaTheta / 2.0; // radians
  static const double startOffset = 1.0; // radians

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.shortestSide / 2.0;
    final Paint paint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius / 10.0;
    final Path path = Path();
    final Rect box = Offset.zero & size;
    for (double theta = 0.0; theta < math.pi * 2.0; theta += deltaTheta) {
      path.addArc(box, theta + startOffset, segmentArc);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(DashOutlineCirclePainter oldDelegate) => false;
}

class MovableBall extends StatelessWidget {
  const MovableBall(this.position, this.pictureOnPosition, this.callback,
      this.name, this.id, this.loggedIn, {Key? key}) : super(key: key);

  final int? position;
  final String? id;
  final bool pictureOnPosition;
  final ValueChanged<FormationPosition> callback;
  final String? name;
  final bool loggedIn;
  static final ValueKey<int> kBallKey =
      ValueKey(DateTime.now().millisecondsSinceEpoch);

  static const double kBallSize = 50.0;

  @override
  Widget build(BuildContext context) {
    String pictureName = "/images/mitglieder/$name.png";
    final Widget ball = DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.bodyLarge!,
      textAlign: TextAlign.center,
      child: DragRoundPicture(
        key: kBallKey,
        image: pictureName,
        size: kBallSize,
        tappable: true,
        // child:  Center(
        //     child: Text(
        //   this.name,
        //   style: TextStyle(color: Colors.black),
        // )),
      ),
    );
    const Widget dashedBall = SizedBox(
      width: kBallSize,
      height: kBallSize,
      child: CustomPaint(painter: DashOutlineCirclePainter()),
    );
    if (pictureOnPosition || position! < 0) {
      if (loggedIn) {
        return Draggable<String>(
          data: name,
          childWhenDragging: dashedBall,
          feedback: ball,
          maxSimultaneousDrags: 1,
          child: ball,
        );
      } else {
        return ball;
      }
    } else {
      return DragTarget<String>(
        onAccept: (String data) {
          callback(FormationPosition(3, data, position, ""));
        },
        builder: (BuildContext context, List<String?> accepted,
            List<dynamic> rejected) {
          return dashedBall;
        },
      );
    }
  }
}
