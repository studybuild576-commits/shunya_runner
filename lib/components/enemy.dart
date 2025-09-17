import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:shunya_runner/components/player.dart';

class EnemyBody extends BodyComponent with ContactCallbacks {
  final Vector2 position;
  final double radius = 9.0;
  final double speed = 100.0;
  final PlayerBody player;

  EnemyBody({required this.position, required this.player});

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.dynamic,
      position: position,
      fixedRotation: true,
      userData: this,
    );
    final enemyBody = world.createBody(bodyDef);
    final shape = CircleShape()..radius = radius;
    final fixtureDef = FixtureDef(shape)
      ..density = 0.8
      ..friction = 0.3
      ..restitution = 0.2;
    enemyBody.createFixture(fixtureDef);
    return enemyBody;
  }

  @override
  void update(double dt) {
    super.update(dt);
    final direction = (player.body.position - body.position)..normalize();
    body.linearVelocity = direction * speed;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = Colors.pink.shade300
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, radius, paint);
  }
}
