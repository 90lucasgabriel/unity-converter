import 'package:flutter/material.dart';
import 'unit.dart';

class Category {
  final String title;
  final ColorSwatch color;
  final String icon;
  final List<Unit> units;

  const Category({
    @required this.title,
    @required this.color,
    @required this.icon,
    @required this.units,
  })  : assert(title != null),
        assert(color != null),
        assert(icon != null),
        assert(units != null);
}
