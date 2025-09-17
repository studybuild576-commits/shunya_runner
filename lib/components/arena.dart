import 'package:flame_forge2d/flame_forge2d.dart';

class Arena extends BodyComponent {
  final Vector2 size;
  Arena({required this.size});

  @override
  Body createBody() {
    final bodyDef = BodyDef(type: BodyType.static, position: Vector2.zero());
    final arenaBody = world.createBody(bodyDef);
    final vertices = [
      size,
      Vector2(size.x, -size.y),
      -size,
      Vector2(-size.x, size.y),
    ];
    final chain = ChainShape()..createLoop(vertices);
    arenaBody.createFixture(FixtureDef(chain));
    return arenaBody;
  }
}
