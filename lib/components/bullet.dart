import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class BulletBody extends BodyComponent {
  // YAHAN BADLAAV KIYA GAYA HAI: @override add kiya
  @override
  final Vector2 position;
  final double radius = 1.5;

  BulletBody({required this.position});

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.dynamic,
      position: position,
      bullet: true, // Tej-raftaar collision ke liye
      userData: this,
    );
    final bulletBody = world.createBody(bodyDef);
    final shape = CircleShape()..radius = radius;
    final fixtureDef = FixtureDef(shape)
      ..isSensor = true; // Bullet takrane par bounce na ho, sirf takkar detect ho
    bulletBody.createFixture(fixtureDef);
    return bulletBody;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, radius, paint);
  }
}
