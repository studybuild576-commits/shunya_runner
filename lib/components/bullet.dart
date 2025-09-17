import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:shunya_runner/components/enemy.dart';

class BulletBody extends BodyComponent with ContactCallbacks {
  @override
  final Vector2 position;
  final Vector2 initialVelocity; // BADLAAV 1: Naya variable
  final double radius = 1.5;

  // BADLAAV 2: Constructor ko update kiya
  BulletBody({required this.position, required this.initialVelocity});

  // BADLAAV 3: Naya method jo body banne ke baad velocity set karega
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    body.linearVelocity = initialVelocity;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.dynamic,
      position: position,
      bullet: true,
      userData: this,
    );
    final bulletBody = world.createBody(bodyDef);
    
    // BADLAAV 4: CircleShape banane ka sahi tarika
    final shape = CircleShape(radius: radius);

    final fixtureDef = FixtureDef(shape)..isSensor = true;
    bulletBody.createFixture(fixtureDef);
    return bulletBody;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is EnemyBody) {
      other.removeFromParent();
      removeFromParent();
    }
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
