import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart' hide PointerMoveEvent;
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
    with KeyboardEvents, PointerMoveCallbacks, TapCallbacks {
  late PlayerBody player;
  Vector2 mousePosition = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewfinder.zoom = 1.5;
    camera.viewfinder.anchor = Anchor.center;

    final sprite = await loadSprite('floor_tile.png');
    add(
      SpriteRepeatComponent(
        sprite: sprite,
        size: Vector2.all(400),
      )..anchor = Anchor.center
    );

    add(Arena(size: Vector2.all(200)));

    player = PlayerBody(position: Vector2.zero());
    add(player);

    add(EnemyBody(position: Vector2(100, 100), player: player));
    add(EnemyBody(position: Vector2(-100, -100), player: player));
  }

  @override
  void update(double dt) {
    super.update(dt);
    player.lookAt(mousePosition);
  }

  @override
  void onPointerMove(PointerMoveEvent event) {
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
