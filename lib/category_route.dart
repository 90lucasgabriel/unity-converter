import 'package:flutter/material.dart';
import 'backdrop.dart';
import 'category.dart';
import 'category_tile.dart';
import 'unit.dart';
import 'unit_converter.dart';

class CategoryRoute extends StatefulWidget {
  CategoryRoute();

  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  Category _defaultCategory;
  Category _currentCategory;
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
    ColorSwatch(0xFF6AB7A8, {
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    ColorSwatch(0xFFFFD28E, {
      'highlight': Color(0xFFFFD28E),
      'splash': Color(0xFFFFA41C),
    }),
    ColorSwatch(0xFFFFB7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
    ColorSwatch(0xFF8899A8, {
      'highlight': Color(0xFF8899A8),
      'splash': Color(0xFFA9CAE8),
    }),
    ColorSwatch(0xFFEAD37E, {
      'highlight': Color(0xFFEAD37E),
      'splash': Color(0xFFFFE070),
    }),
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    ColorSwatch(0xFFCE9A9A, {
      'highlight': Color(0xFFCE9A9A),
      'splash': Color(0xFFF94D56),
      'error': Color(0xFF912D2D),
    }),
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
      var category = Category(
        title: _categoryTitles[i],
        color: _categoryColors[i],
        icon: _categoryIcons[i],
        units: _retrieveUnitList(_categoryTitles[i]),
      );

      if (i == 0) {
        _defaultCategory = category;
      }
      _categories.add(category);
    }
  }

  Widget _buildCategoryWidgets(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return CategoryTile(
            category: _categories[index],
            onTap: _onCategoryTap,
          );
        },
        itemCount: _categories.length,
      );
    } else {
      return GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 4.0,
          children: _categories.map((Category c) {
            return CategoryTile(
              category: c,
              onTap: _onCategoryTap,
            );
          }).toList());
    }
  }

  /// Function to call when a [Category] is tapped.
  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
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
      child: _buildCategoryWidgets(MediaQuery.of(context).orientation),
      color: Colors.transparent,
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 48.0,
      ),
    );

    return Backdrop(
      currentCategory:
          _currentCategory == null ? _defaultCategory : _currentCategory,
      frontPanel: _currentCategory == null
          ? UnitConverter(category: _defaultCategory)
          : UnitConverter(category: _currentCategory),
      backPanel: listView,
      frontTitle: Text('Unit Converter'),
      backTitle: Text('Select a Category'),
    );
  }
}
