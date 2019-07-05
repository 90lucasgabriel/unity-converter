import 'package:flutter/material.dart';
import 'category.dart';
import 'unit.dart';

final _backgroundColor = Colors.amberAccent;

class CategoryRoute extends StatefulWidget {
  CategoryRoute();

  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  final _categories = <Category>[];

  static const List<String> _categoryTitles = <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Time',
    'Digital Storage',
    'Energy',
    'Currency',
  ];

  static const List<ColorSwatch> _categoryColors = <ColorSwatch>[
    Colors.teal,
    Colors.orange,
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.yellow,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.red,
  ];

  static const List<IconData> _categoryIcons = <IconData>[
    Icons.account_circle,
    Icons.train,
    Icons.theaters,
    Icons.track_changes,
    Icons.speaker,
    Icons.slow_motion_video,
    Icons.show_chart,
    Icons.sentiment_neutral
  ];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _categoryTitles.length; i++) {
      _categories.add(Category(
        title: _categoryTitles[i],
        color: _categoryColors[i],
        icon: _categoryIcons[i],
        units: _retrieveUnitList(_categoryTitles[i]),
      ));
    }
  }

  Widget _buildCategoryWidgets() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => _categories[index],
      itemCount: _categories.length,
    );
  }

  /// Returns a list of mock [Unit]s.
  List<Unit> _retrieveUnitList(String categoryName) {
    return List.generate(10, (int i) {
      i += 1;
      return Unit(
        name: '$categoryName Unit $i',
        conversion: i.toDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = <Category>[];

    for (var i = 0; i < _categoryTitles.length; i++) {
      categories.add(Category(
        title: _categoryTitles[i],
        color: _categoryColors[i],
        icon: _categoryIcons[i],
        units: _retrieveUnitList(_categoryTitles[i]),
      ));
    }

    for (var i = 0; i < _categoryTitles.length; i++) {
      categories.add(Category(
        title: _categoryTitles[i],
        color: _categoryColors[i],
        icon: _categoryIcons[i],
        units: _retrieveUnitList(_categoryTitles[i]),
      ));
    }

    final listView = Container(
      child: _buildCategoryWidgets(),
      color: _backgroundColor,
      padding: EdgeInsets.all(8.0),
    );

    final appBar = AppBar(
      elevation: 0.0,
      backgroundColor: _backgroundColor,
      centerTitle: true,
      title: Text(
        'Unit Converter',
        style: TextStyle(fontSize: 30.0, color: Colors.black),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}
