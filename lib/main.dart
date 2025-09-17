import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart'; // Required for keyboard, tap, drag
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shunya_runner/components/arena.dart';
import 'package:shunya_runner/components/bullet.dart';
import 'package:shunya_runner/components/enemy.dart';
import 'package:shunya_runner/components/player.dart';

void main() {
  runApp(
    GameWidget(game: ShunyaRunnerGame()),
  );
}

class ShunyaRunnerGame extends Forge2DGame {
  late PlayerBody player;
  Vector2 mousePosition = Vector2.zero();

  ShunyaRunnerGame() : super(gravity: Vector2.zero());

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Camera setup
    camera.viewfinder.zoom = 1.5;
    camera.viewfinder.anchor = Anchor.center;

    // Floor sprite
    final sprite = await loadSprite('floor_tile.png');
    add(
      SpriteComponent(
        sprite: sprite,
        size: Vector2.all(400),
        anchor: Anchor.center,
      ),
    );

    // Arena
    add(Arena(size: Vector2.all(200)));

    // Player
    player = PlayerBody(position: Vector2.zero());
    add(player);

    // Enemies
    add(EnemyBody(position: Vector2(100, 100), player: player));
    add(EnemyBody(position: Vector2(-100, -100), player: player));

    // Input handlers
    add(KeyboardHandler(player: player));
    add(MouseHandler(player: player));
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}

// Separate component for keyboard input
class KeyboardHandler extends Component with KeyboardHandlerComponent {
  final PlayerBody player;
  KeyboardHandler({required this.player});

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

// Separate component for mouse/tap input
class MouseHandler extends Component with TapCallbacks, DragCallbacks {
  final PlayerBody player;
  Vector2 mousePosition = Vector2.zero();

  MouseHandler({required this.player});

  @override
  bool onTapDown(TapDownEvent event) {
    final tapPosition = event.localPosition.toVector2();
    final direction = (tapPosition - player.body.position)..normalize();
    final velocity = direction * 500.0;

    final bullet = BulletBody(
      position: player.body.position.clone(),
      initialVelocity: velocity,
    );
    player.parent?.add(bullet);
    return true;
  }

  @override
  bool onDragUpdate(int pointerId, DragUpdateEvent event) {
    mousePosition = event.localPosition.toVector2();
    player.lookAt(mousePosition);
    return true;
  }
}
