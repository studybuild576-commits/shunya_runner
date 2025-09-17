import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:shunya_runner/components/player.dart';

class EnemyBody extends BodyComponent with ContactCallbacks {
  @override
  final Vector2 position;
  final double radius = 9.0;
  final double speed = 100.0;
  final PlayerBody player;

  EnemyBody({required this.position, required this.player});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Sprite (image) ko load karega
    final sprite = await game.loadSprite('enemy.png');
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
      userData: this,
    );
    final enemyBody = world.createBody(bodyDef);
    
    // CircleShape banane ka sahi tarika
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
    if (!isMounted || !player.isMounted) return; // Aapka safe check

    final direction = (player.body.position - body.position)..normalize();
    body.linearVelocity = direction * speed;
  }

  // render method hata diya gaya hai
}
