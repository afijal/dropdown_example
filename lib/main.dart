import 'package:dialog_example/dialog_button.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dropdown demwo',
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
            child: SingleChildScrollView(
              child: SizedBox(
                height: 1200,
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
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: _buildDropdownWithLabel(),
                      ),
                    ),
                    SizedBox(height: 450)
                  ],
                ),
              ),
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
        DialogButton(
          items: _items,
          selected: _selected,
          hint: 'Please select a value',
          onChange: _onItemSelected,
        )
      ],
    );
  }
}
