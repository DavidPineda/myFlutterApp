import 'package:flutter/material.dart';

class CategoryItem {
  final String name;
  final Color color;

  const CategoryItem(this.name, this.color)
      : assert(name != null),
        assert(color != null);
}
