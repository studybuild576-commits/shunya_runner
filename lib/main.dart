import 'package:flame/events.dart';
import 'package:flame/game.dart' hide Vector2; // Aapka code waisa hi hai
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart' hide PointerMoveEvent;
import 'package:flutter/services.dart';
import 'package:shunya_runner/components/bullet.dart';
import 'package:shunya_runner/components/enemy.dart';
import 'package:shunya_runner/components/player.dart';

void main() {
  runApp(GameWidget(game: ShunyaRunnerGame()));
}

class ShunyaRunnerGame extends Forge2DGame
    with KeyboardEvents, PointerMoveCallbacks, TapCallbacks {
  late PlayerBody player;
  Vector2 mousePosition = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewfinder.zoom = 10.0;

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

  // SIRF YAHAN BADLAAV KIYA GAYA HAI
  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    
    // 1. Velocity pehle calculate karein
    final tapPosition = screenToWorld(event.localPosition);
    final direction = (tapPosition - player.body.position)..normalize();
    final velocity = direction * 500.0;

    // 2. Velocity ko constructor mein pass karein
    final bullet = BulletBody(
      position: player.body.position.clone(),
      initialVelocity: velocity, // Naya parameter
    );
    
    // 3. Ab add karein (ab koi error nahi aayega)
    add(bullet);
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    Vector2 newMovement = Vector2.zero();

    if (keysPressed.contains(LogicalKeyboardKey.keyW)) newMovement.y = -1;
    if (keysPressed.contains(LogicalKeyboardKey.keyS)) newMovement.y = 1;
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) newMovement.x = -1;
    if (keysPressed.contains(LogicalKeyboardKey.keyD)) newMovement.x = 1;

    player.movement = newMovement;
    return super.onKeyEvent(event, keysPressed);
  }
}
