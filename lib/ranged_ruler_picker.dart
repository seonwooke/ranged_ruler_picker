import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ranged_ruler_picker/ranged_ruler_picker_item_view.dart';

/// A ranged ruler picker widget
///
/// A ruler-style picker that allows users to select values within a specific range
/// by scrolling horizontally. Can be used in financial apps for amount selection
/// or in settings apps for value adjustment.
///
/// Key features:
/// - Intuitive value selection through horizontal scrolling
/// - Snap functionality ensures accurate value selection
/// - Visual feedback (haptic feedback, animations)
/// - Customizable design
class RangedRulerPicker extends StatefulWidget {
  const RangedRulerPicker({
    Key? key,
    required this.min, // Minimum value
    required this.max, // Maximum value
    required this.interval, // Tick interval
    required this.initialValue, // Initial selected value
    required this.onChanged, // Callback when value changes
    required this.labelStyle, // Label text style
    this.shortTickHeight = 8, // Short tick height
    this.longTickHeight = 12, // Long tick height
    this.indicatorColor = Colors.blue, // Indicator line color
    this.rulerColor = Colors.grey, // Ruler tick color
    this.showIndicator = true, // Show indicator line
    this.showLabel = true, // Show labels
    this.hapticFeedback = true, // Enable haptic feedback
    this.backgroundColor = Colors.transparent, // Background color
  })  : assert(min < max, 'min must be less than max'),
        assert(interval > 0, 'interval must be greater than 0'),
        assert(initialValue >= min && initialValue <= max,
            'initialValue must be between min and max'),
        assert(shortTickHeight > 0, 'shortTickHeight must be greater than 0'),
        assert(longTickHeight > 0, 'longTickHeight must be greater than 0'),
        super(key: key);

  /// Minimum selectable value
  final int min;

  /// Maximum selectable value
  final int max;

  /// Tick interval (e.g., 1000 means ticks are displayed every 1000 units)
  final int interval;

  /// Initially selected value
  final int initialValue;

  /// Callback function called when value changes
  final void Function(int) onChanged;

  /// Style for label text
  final TextStyle labelStyle;

  /// Color of ruler ticks
  final Color rulerColor;

  /// Height of short ticks (pixels)
  final int shortTickHeight;

  /// Height of long ticks (pixels, displayed every 5th tick)
  final int longTickHeight;

  /// Color of the indicator line
  final Color indicatorColor;

  /// Whether to show the indicator line
  final bool showIndicator;

  /// Whether to show min/max value labels
  final bool showLabel;

  /// Whether to provide haptic feedback when value changes
  final bool hapticFeedback;

  /// Background color of the widget
  final Color backgroundColor;

  @override
  State<RangedRulerPicker> createState() => _RangedRulerPickerState();
}

/// State management class for RangedRulerPicker
class _RangedRulerPickerState extends State<RangedRulerPicker> {
  /// Controller for horizontal scrolling
  final ScrollController _scrollController = ScrollController();

  /// Width of each tick item (pixels)
  final int _itemWidth = 11;

  /// Total number of ticks
  int _count = 2;

  /// Width of minimum value label
  double _minLabelWidth = 0;

  /// Width of maximum value label
  double _maxLabelWidth = 0;

  /// Actual widget width
  double _widgetWidth = 0;

  /// Label hide state (hidden at boundaries during scroll)
  bool _isHide = false;

  /// Flag to check if snap animation is in progress
  bool _isAnimatingToSnap = false;

  /// Timer for snap animation after scroll stops
  Timer? _stopTimer;

  @override
  void initState() {
    super.initState();

    /// Calculate initial position: set scroll position based on middle value
    final targetOffset =
        (((widget.max / 2) - widget.min) / widget.interval) * _itemWidth;
    _scrollDown(targetOffset);

    /// Calculate total number of ticks
    if (widget.interval == 0) {
      _count = 2;
    } else {
      _count = (widget.max - widget.min) ~/ widget.interval;
    }

    /// Pre-calculate text width for min/max value labels
    _minLabelWidth = _getTextWidth(
      widget.min.toString(),
      widget.labelStyle,
    );
    _maxLabelWidth = _getTextWidth(
      widget.max.toString(),
      widget.labelStyle,
    );

    /// Register scroll event listener
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    /// Clean up resources
    _stopTimer?.cancel();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final widgetWidth = constraints.maxWidth;
        _widgetWidth = widgetWidth;

        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            /// Ruler area - horizontally scrollable ListView
            NotificationListener<ScrollNotification>(
              onNotification: _handleScrollNotification,
              child: Container(
                color: widget.backgroundColor,
                height: widget.showLabel
                    ? widget.longTickHeight.toDouble() + 44
                    : 32,
                child: ScrollConfiguration(
                  /// Enable scrolling for both touch and mouse
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: ListView.builder(
                    itemCount: _count + 1,
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,

                    /// Adjust center indicator position with left/right padding
                    padding: EdgeInsets.only(
                      left: widgetWidth / 2,
                      right: widgetWidth / 2,
                    ),
                    itemBuilder: (context, index) {
                      /// Calculate actual value for each item
                      final value = widget.min + (widget.interval * index);

                      return RangedRulerPickerItemView(
                        min: widget.min,
                        max: widget.max,
                        labelStyle: widget.labelStyle,
                        rulerColor: widget.rulerColor,
                        shortTickHeight: widget.shortTickHeight,
                        longTickHeight: widget.longTickHeight,
                        isHide: widget.showLabel ? _isHide : false,
                        showLabel: widget.showLabel,
                        backgroundColor: widget.backgroundColor,
                        value: value,
                        index: index,
                        isLast: index == _count,
                      );
                    },
                  ),
                ),
              ),
            ),

            /// Indicator line - shows currently selected value
            if (widget.showIndicator)
              Positioned(
                bottom: widget.showLabel ? 24 : 0,
                child: Container(
                  height: 32,
                  width: 4,
                  decoration: BoxDecoration(
                    color: widget.indicatorColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),

            /// Min/max value label area
            if (widget.showLabel)
              Positioned(
                bottom: 0,
                child: Opacity(
                  opacity: _isHide ? 0 : 1,
                  child: Container(
                    width: widgetWidth,
                    color: widget.backgroundColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.min.toString(),
                          style: widget.labelStyle,
                        ),
                        Text(
                          widget.max.toString(),
                          style: widget.labelStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Method to move to initial scroll position
  void _scrollDown(double targetOffset) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(targetOffset);
    });
  }

  /// Scroll event handler
  void _onScroll() {
    final width =
        _widgetWidth > 0 ? _widgetWidth : MediaQuery.of(context).size.width;

    /// Hide labels at boundary areas
    /// Left boundary: when min value label crosses the indicator line
    if ((_scrollController.offset + (_minLabelWidth / 2)) <= (width / 2)) {
      setState(() {
        _isHide = true;
      });
    }

    /// Right boundary: when max value label crosses the indicator line
    else if (_scrollController.offset >=
        (_count * _itemWidth) - (width / 2 - (_maxLabelWidth / 2))) {
      setState(() {
        _isHide = true;
      });
    }

    /// Middle area: show labels
    else {
      setState(() {
        _isHide = false;
      });
    }

    /// Calculate selected value based on current scroll position
    final newValue = widget.min +
        ((_scrollController.offset / _itemWidth).round() * widget.interval);

    /// Clamp value within min/max range
    final clampedValue = newValue.clamp(widget.min, widget.max);

    /// Only call callback and provide feedback when value actually changes
    if (clampedValue != widget.initialValue) {
      widget.onChanged(clampedValue);
      if (widget.hapticFeedback) {
        HapticFeedback.lightImpact();
      }
    }
  }

  /// Scroll notification handler
  /// Provides snap functionality to align with nearest tick when scrolling stops
  bool _handleScrollNotification(ScrollNotification notification) {
    /// Only process when scroll ends and not currently animating to snap
    if (notification is ScrollEndNotification && !_isAnimatingToSnap) {
      /// Calculate nearest value to current scroll position
      final newValue = widget.min +
          ((_scrollController.offset / _itemWidth).round() * widget.interval);

      /// Cancel previous timer and start new one
      _stopTimer?.cancel();
      _stopTimer = Timer(const Duration(milliseconds: 100), () {
        if (mounted && _scrollController.hasClients) {
          _isAnimatingToSnap = true; // Start snap animation

          /// Calculate exact snap position
          /// Consider cases where min is not 0
          final snapOffset = ((newValue - widget.min) / widget.interval) *
              _itemWidth.toDouble();

          /// Smoothly animate to snap position
          _scrollController
              .animateTo(
            snapOffset,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOutCubic,
          )
              .then((_) {
            _isAnimatingToSnap = false; // Snap animation complete
          });
          setState(() {});
        }
      });
    }

    return false;
  }

  /// Utility method to calculate actual text width
  /// Used for label position calculation
  double _getTextWidth(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(); // Perform text size measurement

    return textPainter.width; // Return text width
  }
}
