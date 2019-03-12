import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'unit.dart';

class Category {
  final String name;
  final ColorSwatch color;
  final IconData iconLocation;
  final List<Unit> units;

  const Category(
      {@required this.color,
      @required this.iconLocation,
      @required this.name,
      @required this.units})
      : assert(color != null),
        assert(iconLocation != null),
        assert(name != null),
        assert(units != null);
}
