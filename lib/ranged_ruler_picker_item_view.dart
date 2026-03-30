import 'package:flutter/material.dart';

/// Widget that renders individual items for the ruler picker
///
/// Displays each tick and label, with long ticks every 5th position to
/// help users easily read values.
///
/// Key features:
/// - Short/long tick display (long ticks every 5th position)
/// - Min/max value label display
/// - Label hiding during scroll
class RangedRulerPickerItemView extends StatelessWidget {
  const RangedRulerPickerItemView({
    Key? key,
    required this.min,
    required this.max,
    required this.labelStyle,
    required this.rulerColor,
    required this.shortTickHeight,
    required this.longTickHeight,
    required this.isHide,
    required this.showLabel,
    required this.value,
    required this.index,
    required this.isLast,
  }) : super(key: key);

  /// Overall range minimum value
  final int min;

  /// Overall range maximum value
  final int max;

  /// Label text style
  final TextStyle labelStyle;

  /// Ruler tick color
  final Color rulerColor;

  /// Short tick height (pixels)
  final int shortTickHeight;

  /// Long tick height (pixels)
  final int longTickHeight;

  /// Show labels
  final bool showLabel;

  /// Label hide state (hidden at boundaries during scroll)
  final bool isHide;

  /// Value represented by current item
  final int value;

  /// Item index (starts from 0)
  final int index;

  /// Whether this is the last item
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        /// Row containing ticks and labels
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            /// Tick container
            Container(
              /// Display long ticks for every 5th index, short ticks otherwise
              height: index % 5 == 0
                  ? longTickHeight.toDouble()
                  : shortTickHeight.toDouble(),
              width: 1,
              color: rulerColor,

              /// Only show labels for minimum value (first) or maximum value (last)
              child: showLabel && (index == 0 || isLast)
                  ? OverflowBox(
                      /// Allow labels to occupy larger area than ticks
                      maxHeight: longTickHeight.toDouble() + 44,
                      maxWidth: 100,
                      child: Padding(
                        /// Adjust label position: different padding for long vs short ticks
                        padding: EdgeInsets.only(
                            top: index % 5 == 0
                                ? longTickHeight.toDouble() + 31
                                : longTickHeight.toDouble() + 29),
                        child: Opacity(
                          /// Visible when scrolled to edges (isHide = true means at boundary)
                          opacity: isHide ? 1 : 0,
                          child: Text(
                            /// First item shows min value, last item shows max value
                            index == 0 ? min.toString() : max.toString(),
                            style: labelStyle,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),

            /// Spacing between items (no spacing for last item)
            SizedBox(width: isLast ? 0 : 10),
          ],
        ),

        /// Spacing for label display area
        SizedBox(height: showLabel ? 8 : 0),

        /// Reserve label height so ticks align above the label area
        if (showLabel)
          Text(
            '',
            style: labelStyle,
          ),
      ],
    );
  }
}
