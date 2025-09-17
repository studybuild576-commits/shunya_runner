import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/player.dart';
import 'components/enemy.dart';
import 'components/bullet.dart';
import 'components/arena.dart';

void main() {
  runApp(GameWidget(game: ShunyaRunnerGame()));
}

class ShunyaRunnerGame extends Forge2DGame with HasKeyboardHandlerComponents, HasDraggables, HasTappables {
  late PlayerBody player;

  ShunyaRunnerGame() : super(gravity: Vector2.zero());

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Camera zoom
    camera.viewfinder.zoom = 1.5;

    // Arena
    add(Arena(size: Vector2.all(200)));

    // Player
    player = PlayerBody(position: Vector2.zero());
    add(player);

    // Enemies
    add(EnemyBody(position: Vector2(100, 100), player: player));
    add(EnemyBody(position: Vector2(-100, -100), player: player));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Camera follow player
    camera.followVector2(player.body.position);
  }
}

// Keyboard input handler
class PlayerKeyboard extends Component with KeyboardHandlerComponent {
  final PlayerBody player;

  PlayerKeyboard({required this.player});

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    Vector2 newMovement = Vector2.zero();
    if (keysPressed.contains(LogicalKeyboardKey.keyW)) newMovement.y = -1;
    if (keysPressed.contains(LogicalKeyboardKey.keyS)) newMovement.y = 1;
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) newMovement.x = -1;
    if (keysPressed.contains(LogicalKeyboardKey.keyD)) newMovement.x = 1;

    player.movement = newMovement;
    return KeyEventResult.handled;
  }
}

// Mouse drag & tap handler
class PlayerMouse extends PositionComponent with TapDetector, DragDetector {
  final PlayerBody player;

  PlayerMouse({required this.player});

  @override
  void onTapDown(TapDownInfo info) {
    final tapPosition = info.eventPosition.game;
    final direction = (tapPosition - player.body.position)..normalize();
    final velocity = direction * 500.0;

    final bullet = BulletBody(
      position: player.body.position.clone(),
      initialVelocity: velocity,
    );
    parent?.add(bullet);
  }

  @override
  void onDragUpdate(DragUpdateInfo info) {
    final pos = info.eventPosition.game;
    player.lookAt(pos);
  }
}
