import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class PlayerBody extends BodyComponent {
  @override
  final Vector2 position;
  final double radius = 8.0;
  Vector2 movement = Vector2.zero();
  final double speed = 200.0;

  PlayerBody({required this.position});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Sprite (image) ko load karega
    final sprite = await game.loadSprite('player.png');
    add(
      SpriteComponent(
        sprite: sprite,
        size: Vector2.all(radius * 2.5), // Image ka size adjust kiya
        anchor: Anchor.center,
      ),
    );
  }

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

    // CircleShape banane ka sahi tarika
    final shape = CircleShape(radius: radius);

    final fixtureDef = FixtureDef(shape)
      ..density = 1.0
      ..friction = 0.4;
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
}
