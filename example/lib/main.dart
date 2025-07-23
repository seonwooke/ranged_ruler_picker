import 'package:flutter/material.dart';
import 'package:ranged_ruler_picker/ranged_ruler_picker.dart';

void main() => runApp(RangeRulerPickerDemo());

class RangeRulerPickerDemo extends StatefulWidget {
  @override
  State<RangeRulerPickerDemo> createState() => _RangeRulerPickerDemoState();
}

class _RangeRulerPickerDemoState extends State<RangeRulerPickerDemo> {
  var text = '';

  @override
  void initState() {
    super.initState();
    text = '50';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'ranged_ruler_picker',
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              spacing: 24,
              children: [
                SizedBox(height: 100),
                RangedRulerPicker(
                  min: 0,
                  max: 100,
                  interval: 3,
                  initialValue: 50,
                  onChanged: (value) {
                    setState(() {
                      text = value.toString();
                    });
                  },
                  labelStyle: const TextStyle(fontSize: 12),
                ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
