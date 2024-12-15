// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';

/// Callback for building the expander icon or content.
///
/// Example:
/// ```dart
/// Widget buildExpander(BuildContext context, bool isExpanded, Animation<double> animation) {
///   return RotationTransition(
///     turns: animation,
///     child: Icon(Icons.chevron_right),
///   );
/// }
/// ```
typedef ExpanderBuilder = Widget Function(
  BuildContext context,
  bool isExpanded,
  Animation<double> animation,
);

/// An animated widget that can expand or collapse its children with smooth transitions.
///
/// Example:
/// ```dart
/// Expander<String>(
///   contentBuilder: (context, isExpanded, animation) {
///     return Text('Content');
///   },
///   children: [
///     Text('Child 1'),
///     Text('Child 2'),
///   ],
///   onExpansionChanged: (expanded) {
///     print('Expanded: $expanded');
///   },
///   isExpanded: ValueNotifier(false),
///   expanderBuilder: (context, isExpanded, animation) {
///     return Icon(isExpanded ? Icons.expand_more : Icons.chevron_right);
///   },
/// )
/// ```
class Expander<T> extends StatefulWidget {
  /// Creates an expander widget with the specified parameters.
  const Expander({
    required this.contentBuilder,
    required this.children,
    required this.onExpansionChanged,
    required this.isExpanded,
    required this.expanderBuilder,
    this.canExpand = true,
    super.key,
    this.animationCurve = Curves.easeInOut,
    this.animationDuration = const Duration(milliseconds: 500),
    this.contentPadding,
    this.minHeight,
    this.minVerticalPadding,
  });

  /// The widgets to show when the expander is expanded.
  final List<Widget> children;

  /// Called when the expansion state changes.
  final ValueChanged<bool> onExpansionChanged;

  /// Controls the expansion state of the widget.
  final ValueNotifier<bool> isExpanded;

  /// Whether this widget can be expanded (shows an expander icon).
  final bool canExpand;

  /// Builds the expander icon (typically an arrow or chevron).
  final ExpanderBuilder expanderBuilder;

  /// Builds the main content of the expander.
  final ExpanderBuilder contentBuilder;

  /// The animation curve for expand/collapse transitions.
  final Curve animationCurve;

  /// The duration of expand/collapse animations.
  final Duration animationDuration;

  /// The padding around the content. The default is 16.0.
  final EdgeInsetsGeometry? contentPadding;

  /// The minimum height of the tile. The default depends on factors that may be out of your
  /// control so it is recommended to set this value.
  final double? minHeight;

  /// The minimum vertical padding of the tile. The default is 4.0.
  final double? minVerticalPadding;

  @override
  State<Expander<T>> createState() => _ExpanderState();
}

class _ExpanderState<T> extends State<Expander<T>>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expanderAnimation;
  late Animation<double> _contentAnimation;
  late ValueNotifier<bool> _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
    _init();
  }

  @override
  void didUpdateWidget(Expander<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initAnimations();

    _isExpanded
      ..removeListener(_animate)
      ..addListener(_animate);
  }

  void _initAnimations() {
    _controller.duration = widget.animationDuration;

    _expanderAnimation = Tween<double>(begin: 0, end: 0.25).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.animationCurve,
      ),
    );

    _contentAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    );
  }

  void _init() {
    _isExpanded.addListener(_animate);
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _initAnimations();
  }

  @override
  void dispose() {
    widget.isExpanded.removeListener(_animate);
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onExpansionChanged(!widget.isExpanded.value);
    setState(_animate);
  }

  void _animate() {
    if (widget.isExpanded.value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            minTileHeight: widget.minHeight,
            contentPadding: widget.contentPadding,
            onTap: _handleTap,
            minVerticalPadding: widget.minVerticalPadding,
            leading: widget.canExpand
                ? widget.expanderBuilder(
                    context,
                    widget.isExpanded.value,
                    _expanderAnimation,
                  )
                : null,
            title: widget.contentBuilder(
              context,
              widget.isExpanded.value,
              _contentAnimation,
            ),
          ),
          SizeTransition(
            sizeFactor: _contentAnimation,
            child: Column(children: widget.children),
          ),
        ],
      );
}
