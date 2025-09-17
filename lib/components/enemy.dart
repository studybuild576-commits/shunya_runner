import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:shunya_runner/components/player.dart';

class EnemyBody extends BodyComponent with ContactCallbacks {
  final Vector2 initialPosition;
  final double radius = 9.0;
  final double speed = 100.0;
  final PlayerBody player;

  EnemyBody({required this.initialPosition, required this.player});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await game.loadSprite('enemy.png');
    add(
      SpriteComponent(
        sprite: sprite,
        size: Vector2.all(radius * 2.5),
        anchor: Anchor.center,
      ),
    );
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
        type: BodyType.dynamic,
        position: initialPosition,
        fixedRotation: true,
        userData: this);
    final enemyBody = world.createBody(bodyDef);
    final shape = CircleShape(radius: radius);
    final fixtureDef = FixtureDef(shape)
      ..density = 0.8
      ..friction = 0.3;
    enemyBody.createFixture(fixtureDef);
    return enemyBody;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!player.isMounted || !isMounted) return;
    final direction = (player.body.position - body.position)..normalize();
    body.linearVelocity = direction * speed;
  }
}
