// IMPORTS
import 'package:flame/components.dart';
import 'package:flame/events.dart' as flame_events; // Alias for Flame events
import 'package:flame/game.dart';
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

class ShunyaRunnerGame extends Forge2DGame
    with KeyboardEvents, flame_events.PointerMoveCallbacks, TapCallbacks {
  late PlayerBody player;
  Vector2 mousePosition = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Camera setup
    camera.viewfinder.zoom = 1.5;
    camera.viewfinder.anchor = Anchor.center;

    // Floor sprite (simple version)
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
  }

  @override
  void update(double dt) {
    super.update(dt);
    player.lookAt(mousePosition);
  }

  @override
  void onPointerMove(flame_events.PointerMoveEvent event) {
    mousePosition = screenToWorld(event.localPosition);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    final tapPosition = screenToWorld(event.localPosition);
    final direction = (tapPosition - player.body.position)..normalize();
    final velocity = direction * 500.0;

    final bullet = BulletBody(
      position: player.body.position.clone(),
      initialVelocity: velocity,
    );
    add(bullet);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    Vector2 newMovement = Vector2.zero();
    if (keysPressed.contains(LogicalKeyboardKey.keyW)) newMovement.y = -1;
    if (keysPressed.contains(LogicalKeyboardKey.keyS)) newMovement.y = 1;
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) newMovement.x = -1;
    if (keysPressed.contains(LogicalKeyboardKey.keyD)) newMovement.x = 1;

    player.movement = newMovement;
    return super.onKeyEvent(event, keysPressed);
  }
}
