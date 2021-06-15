import 'package:flutter/material.dart';

import 'closeable_dropdown.dart';
import 'custom_dropdown.dart';

void main() {
  runApp(MyApp());
}

//TODO:
// dopiesc
// live coding czy walthrough?
// dopiesc kod do perfekcji
// dodaj tez komenty co jest po co
// dokoncz scxenariusz
//check continuity sketch

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dropdown demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _items = [
    'First item',
    'Second item',
    'Third item',
    'Fourth item which is a very long one',
  ];

  String? _selected;

  void _onItemSelected(String item) {
    setState(() {
      _selected = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown demo'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Your choice:',
          ),
          SizedBox(
            height: 8,
          ),
          CustomDropdown(
            items: _items,
            selected: _selected,
            hint: 'Please select a value',
            onChange: _onItemSelected,
          )
        ],
      ),
    );
  }
}
