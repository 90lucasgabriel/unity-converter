import 'package:flutter/material.dart';
import 'category.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hello Rectangle',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hello Rectangles'),
        ),
        body: UnitConverterApp(),
      ),
    ),
  );
}

class UnitConverterApp extends StatelessWidget {
  final String _categoryTitle = 'Gabriel';
  final ColorSwatch _categoryColor = Colors.grey;
  final IconData _categoryIcon = Icons.account_circle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Category(
        title: _categoryTitle,
        color: _categoryColor,
        icon: _categoryIcon,
      ),
    );
  }
}
