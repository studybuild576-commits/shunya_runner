import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:shunya_runner/components/enemy.dart';

class BulletBody extends BodyComponent with ContactCallbacks {
  @override
  final Vector2 position;
  final Vector2 initialVelocity;
  final double radius = 3.0;

  BulletBody({required this.position, required this.initialVelocity});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    body.linearVelocity = initialVelocity;

    final sprite = await game.loadSprite('bullet.png');
    add(
      SpriteComponent(
        sprite: sprite,
        size: Vector2.all(radius * 2),
        anchor: Anchor.center,
      ),
    );
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(type: BodyType.dynamic, position: position, bullet: true, userData: this);
    final bulletBody = world.createBody(bodyDef);
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
}
