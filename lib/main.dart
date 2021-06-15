import 'package:dialog_example/%20no_position/closeable_dropdown_no_position.dart';
import 'package:flutter/material.dart';

import 'final/closeable_dropdown_final.dart';

void main() {
  runApp(MyApp());
}

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
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: _buildDropdownWithLabel(),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildDropdownWithLabel()),
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(child: _buildDropdownWithLabel()),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildDropdownWithLabel(),
                )
              ],
            )),
      ),
    );
  }

  Widget _buildDropdownWithLabel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'Your choice:',
        ),
        SizedBox(
          height: 8,
        ),
        CloseableDropdownFinal(
          items: _items,
          selected: _selected,
          hint: 'Please select a value',
          onChange: _onItemSelected,
        )
      ],
    );
  }
}
