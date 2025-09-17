import 'dart:ui';
import 'package:vector_math/vector_math_64.dart';

/// Fix for Vector2 → Offset conversion
extension Vector2Extension on Vector2 {
  Offset toOffset() => Offset(x, y);
}
