import 'dart:math';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class PlayerBody extends BodyComponent {
  @override
  final Vector2 position;
  final double radius = 8.0;
  Vector2 movement = Vector2.zero();
  final double speed = 200.0;

  PlayerBody({required this.position});

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.dynamic,
      position: position,
      fixedRotation: true,
      linearDamping: 0.5,
      userData: this,
    );
    final playerBody = world.createBody(bodyDef);

    final shape = CircleShape()..radius = radius;

    final fixtureDef = FixtureDef(shape)
      ..density = 1.0
      ..friction = 0.4
      ..restitution = 0.1;

    playerBody.createFixture(fixtureDef);
    return playerBody;
  }

  @override
  void update(double dt) {
    super.update(dt);
    body.linearVelocity = movement * speed;
  }

  void lookAt(Vector2 target) {
    final angle = atan2(target.y - body.position.y, target.x - body.position.x);
    body.setTransform(body.position, angle);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, radius, paint);

    final directionPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    final directionVector = Vector2(cos(body.angle) * radius, sin(body.angle) * radius);
    canvas.drawLine(Offset.zero, directionVector.toOffset(), directionPaint);
  }
}
