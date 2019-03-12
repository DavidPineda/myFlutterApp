import 'package:flutter/material.dart';
import 'package:my_app_flutter/category.dart';

final _backgroundColor = Colors.green[100];

class CategoryItem {
  String name;
  Color color;

  CategoryItem(this.name, this.color);
}

class CategoryRoute extends StatelessWidget {

  CategoryRoute();

  List<CategoryItem> _categories = new List();


  Widget _buildCategoryWidgets(List<Widget> categories) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => categories[index],
      itemCount: categories.length,
    );
  }

  void fillList() {
    this._categories.add(new CategoryItem('Length', Colors.teal));
    this._categories.add(new CategoryItem('Area', Colors.orange));
    this._categories.add(new CategoryItem('Volume', Colors.pinkAccent));
    this._categories.add(new CategoryItem('Mass', Colors.blueAccent));
    this._categories.add(new CategoryItem('Time', Colors.yellow));
    this._categories.add(new CategoryItem('Digital Storage', Colors.greenAccent));
    this._categories.add(new CategoryItem('Energy', Colors.purpleAccent));
    this._categories.add(new CategoryItem('Currency', Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    this.fillList();
    final categories = <Category>[];

    for (var i = 0; i < _categories.length; i++) {
      categories.add(Category(
        name: _categories[i].name,
        color: _categories[i].color,
        iconLocation: Icons.cake,
      ));
    }

    final listView = Container(
      color: _backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: _buildCategoryWidgets(categories),
    );

    final appBar = AppBar(
      elevation: 0.0,
      title: Text(
        'Unit Converter',
        style: TextStyle(
          color: Colors.black,
          fontSize: 30.0,
        ),
      ),
      centerTitle: true,
      backgroundColor: _backgroundColor,
    );

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}