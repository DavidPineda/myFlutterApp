import 'package:flutter/material.dart';

class CategoryItem {
  final String name;
  final ColorSwatch color;
  final String iconLocation;

  const CategoryItem(
    this.name,
    this.color,
    this.iconLocation,
  )   : assert(name != null),
        assert(color != null),
        assert(iconLocation != null);
}
