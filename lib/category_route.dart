import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'backdrop.dart';
import 'category.dart';
import 'category_tile.dart';
import 'unit.dart';
import 'unit_converter.dart';
import 'category_item.dart';
import 'api.dart';

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
    this._retrieveCategoryItems();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    // We have static unit conversions located in our
    // assets/data/regular_units.json
    if (_categories.isEmpty) {
      await _retrieveLocalCategories();
      await _retrieveApiCategory();
    }
  }

  /// Retrieves a list of [Categories] and their [Unit]s
  Future<void> _retrieveLocalCategories() async {
    // Consider omitting the types for local variables. For more details on Effective
    // Dart Usage, see https://www.dartlang.org/guides/language/effective-dart/usage
    final json = DefaultAssetBundle
        .of(context)
        .loadString('assets/data/regular_units.json');
    final data = JsonDecoder().convert(await json);
    if (data is! Map) {
      throw ('Data retrieved from API is not a Map');
    }
    var categoryIndex = 0;
    data.keys.forEach((key) {
      final List<Unit> units =
      data[key].map<Unit>((dynamic data) => Unit.fromJson(data)).toList();

      var category = Category(
        name: key,
        units: units,
        color: categoriesItems[categoryIndex].color,
        iconLocation: categoriesItems[categoryIndex].iconLocation,
      );
      setState(() {
        if (categoryIndex == 0) {
          _defaultCategory = category;
        }
        _categories.add(category);
      });
      categoryIndex += 1;
    });
  }

  /// Retrieves a [Category] and its [Unit]s from an API on the web
  Future<void> _retrieveApiCategory() async {
    // Add a placeholder while we fetch the Currency category using the API
    setState(() {
      _categories.add(Category(
        name: apiCategory['name'],
        units: [],
        color: categoriesItems.last.color,
        iconLocation: categoriesItems.last.iconLocation,
      ));
    });
    final api = Api();
    final jsonUnits = await api.getUnits(apiCategory['route']);
    // If the API errors out or we have no internet connection, this category
    // remains in placeholder mode (disabled)
    if (jsonUnits != null) {
      final units = <Unit>[];
      for (var unit in jsonUnits) {
        units.add(Unit.fromJson(unit));
      }
      setState(() {
        _categories.removeLast();
        _categories.add(Category(
          name: apiCategory['name'],
          units: units,
          color: categoriesItems.last.color,
          iconLocation: categoriesItems.last.iconLocation,
        ));
      });
    }
  }

  /// Function to call when a [Category] is tapped.
  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  Widget _buildCategoryWidgets(Orientation deviceOrientation) {
    if (deviceOrientation == Orientation.portrait) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var _category = _categories[index];
          return CategoryTile(
            category: _category,
            onTap:
            _category.name == apiCategory['name'] && _category.units.isEmpty
                ? null
                : _onCategoryTap,
          );
        },
        itemCount: _categories.length,
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.0,
        children: _categories.map((Category c) {
          return CategoryTile(
            category: c,
            onTap: _onCategoryTap,
          );
        }).toList(),
      );
    }
  }

  void _retrieveCategoryItems() {
    this.categoriesItems.add(new CategoryItem(
      'Length',
      ColorSwatch(0xFF6AB7A8, {
        'highlight': Color(0xFF6AB7A8),
        'splash': Color(0xFF0ABC9B),
      }),
      'assets/icons/length.png',
    ));
    this.categoriesItems.add(new CategoryItem(
      'Area',
      ColorSwatch(0xFFFFD28E, {
        'highlight': Color(0xFFFFD28E),
        'splash': Color(0xFFFFA41C),
      }),
      'assets/icons/area.png',
    ));
    this.categoriesItems.add(new CategoryItem(
      'Volume',
      ColorSwatch(0xFFFFB7DE, {
        'highlight': Color(0xFFFFB7DE),
        'splash': Color(0xFFF94CBF),
      }),
      'assets/icons/volume.png',
    ));
    this.categoriesItems.add(new CategoryItem(
      'Mass',
      ColorSwatch(0xFF8899A8, {
        'highlight': Color(0xFF8899A8),
        'splash': Color(0xFFA9CAE8),
      }),
      'assets/icons/mass.png',
    ));
    this.categoriesItems.add(new CategoryItem(
      'Time',
      ColorSwatch(0xFFEAD37E, {
        'highlight': Color(0xFFEAD37E),
        'splash': Color(0xFFFFE070),
      }),
      'assets/icons/time.png',
    ));
    this.categoriesItems.add(new CategoryItem(
      'Digital Storage',
      ColorSwatch(0xFF81A56F, {
        'highlight': Color(0xFF81A56F),
        'splash': Color(0xFF7CC159),
      }),
      'assets/icons/digital_storage.png',
    ));
    this.categoriesItems.add(new CategoryItem(
      'Energy',
      ColorSwatch(0xFFD7C0E2, {
        'highlight': Color(0xFFD7C0E2),
        'splash': Color(0xFFCA90E5),
      }),
      'assets/icons/power.png',
    ));
    this.categoriesItems.add(new CategoryItem(
      'Currency',
      ColorSwatch(0xFFCE9A9A, {
        'highlight': Color(0xFFCE9A9A),
        'splash': Color(0xFFF94D56),
        'error': Color(0xFF912D2D),
      }),
      'assets/icons/currency.png',
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (_categories.isEmpty) {
      return Center(
        child: Container(
          height: 180.0,
          width: 180.0,
          child: CircularProgressIndicator(),
        ),
      );
    }

    assert(debugCheckHasMediaQuery(context));
    final listView = Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 48.0,
      ),
      child: _buildCategoryWidgets(MediaQuery.of(context).orientation),
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
