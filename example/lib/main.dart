import 'package:flutter/material.dart';
import 'package:ranged_ruler_picker/ranged_ruler_picker.dart';

void main() => runApp(RangeRulerPickerDemo());

class RangeRulerPickerDemo extends StatefulWidget {
  @override
  State<RangeRulerPickerDemo> createState() => _RangeRulerPickerDemoState();
}

class _RangeRulerPickerDemoState extends State<RangeRulerPickerDemo> {
  var _defaultValue = '50';
  var _weightValue = '90';
  var _priceValue = '50000';
  var _temperatureValue = '20';
  var _customStyleValue = '500';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('ranged_ruler_picker'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 32,
            children: [
              // 1. Default
              _buildSection(
                title: 'Default (0~100, interval: 1)',
                value: _defaultValue,
                child: RangedRulerPicker(
                  min: 0,
                  max: 100,
                  interval: 1,
                  initialValue: 50,
                  onChanged: (v) => setState(() => _defaultValue = '$v'),
                  labelStyle: const TextStyle(fontSize: 12),
                ),
              ),

              // 2. Weight picker (issue reporter's case)
              _buildSection(
                title: 'Weight (50~200, interval: 1, initial: 90)',
                value: '$_weightValue kg',
                child: RangedRulerPicker(
                  min: 50,
                  max: 200,
                  interval: 1,
                  initialValue: 90,
                  onChanged: (v) => setState(() => _weightValue = '$v'),
                  indicatorColor: Colors.red,
                  labelStyle: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),

              // 3. Price picker (large range, large interval)
              _buildSection(
                title: 'Price (0~100,000, interval: 1000)',
                value: '₩$_priceValue',
                child: RangedRulerPicker(
                  min: 0,
                  max: 100000,
                  interval: 1000,
                  initialValue: 50000,
                  onChanged: (v) => setState(() => _priceValue = '$v'),
                  indicatorColor: Colors.green,
                  labelStyle: const TextStyle(fontSize: 11),
                ),
              ),

              // 4. Temperature (negative min)
              _buildSection(
                title: 'Temperature (-30~50, interval: 5)',
                value: '$_temperatureValue°C',
                child: RangedRulerPicker(
                  min: -30,
                  max: 50,
                  interval: 5,
                  initialValue: 20,
                  onChanged: (v) => setState(() => _temperatureValue = '$v'),
                  indicatorColor: Colors.orange,
                  rulerColor: Colors.blueGrey,
                  labelStyle: const TextStyle(fontSize: 12),
                ),
              ),

              // 5. Custom style (no label, no indicator, custom colors)
              _buildSection(
                title: 'Custom Style (no label, no indicator)',
                value: _customStyleValue,
                child: RangedRulerPicker(
                  min: 0,
                  max: 1000,
                  interval: 10,
                  initialValue: 500,
                  onChanged: (v) => setState(() => _customStyleValue = '$v'),
                  showLabel: false,
                  showIndicator: false,
                  rulerColor: Colors.purple,
                  backgroundColor: Colors.purple.shade50,
                  labelStyle: const TextStyle(fontSize: 12),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String value,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        child,
        Center(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
