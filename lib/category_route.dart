import 'package:flutter/material.dart';

import 'backdrop.dart';
import 'category.dart';
import 'category_tile.dart';
import 'unit.dart';
import 'unit_converter.dart';
import 'category_item.dart';

class CategoryRoute extends StatefulWidget {
  CategoryRoute();

  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  Category _defaultCategory;
  Category _currentCategory;
  final _categories = <Category>[];
  List<CategoryItem> categoriesItems = new List();

  @override
  void initState() {
    super.initState();
    this._retreiveCategoryItems();

    for (var i = 0; i < categoriesItems.length; i++) {
      var category = Category(
        name: categoriesItems[i].name,
        color: categoriesItems[i].color,
        iconLocation: Icons.cake,
        units: _retreiveUnitList(categoriesItems[i].name),
      );
      if (i == 0) {
        _defaultCategory = category;
      }
      _categories.add(category);
    }
  }

  /// Function to call when a [Category] is tapped.
  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  Widget _buildCategoryWidgets() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return CategoryTile(
          category: _categories[index],
          onTap: _onCategoryTap,
        );
      },
      itemCount: _categories.length,
    );
  }

  List<Unit> _retreiveUnitList(String categoryName) {
    return List.generate(10, (int i) {
      i += 1;
      return Unit(
        name: '$categoryName Unit $i',
        conversion: i.toDouble(),
      );
    });
  }

  void _retreiveCategoryItems() {
    this.categoriesItems.add(new CategoryItem(
      'Length',
      ColorSwatch(0xFF6AB7A8, {
        'highlight': Color(0xFF6AB7A8),
        'splash': Color(0xFF0ABC9B),
      }),
    ));
    this.categoriesItems.add(new CategoryItem(
      'Area',
      ColorSwatch(0xFFFFD28E, {
        'highlight': Color(0xFFFFD28E),
        'splash': Color(0xFFFFA41C),
      }),
    ));
    this.categoriesItems.add(new CategoryItem(
      'Volume',
      ColorSwatch(0xFFFFB7DE, {
        'highlight': Color(0xFFFFB7DE),
        'splash': Color(0xFFF94CBF),
      }),
    ));
    this.categoriesItems.add(new CategoryItem(
      'Mass',
      ColorSwatch(0xFF8899A8, {
        'highlight': Color(0xFF8899A8),
        'splash': Color(0xFFA9CAE8),
      }),
    ));
    this.categoriesItems.add(new CategoryItem(
      'Time',
      ColorSwatch(0xFFEAD37E, {
        'highlight': Color(0xFFEAD37E),
        'splash': Color(0xFFFFE070),
      }),
    ));
    this.categoriesItems.add(new CategoryItem(
      'Digital Storage',
      ColorSwatch(0xFF81A56F, {
        'highlight': Color(0xFF81A56F),
        'splash': Color(0xFF7CC159),
      }),
    ));
    this.categoriesItems.add(new CategoryItem(
      'Energy',
      ColorSwatch(0xFFD7C0E2, {
        'highlight': Color(0xFFD7C0E2),
        'splash': Color(0xFFCA90E5),
      }),
    ));
    this.categoriesItems.add(new CategoryItem(
      'Currency',
      ColorSwatch(0xFFCE9A9A, {
        'highlight': Color(0xFFCE9A9A),
        'splash': Color(0xFFF94D56),
        'error': Color(0xFF912D2D),
      }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final listView = Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 48.0,
      ),
      child: _buildCategoryWidgets(),
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
