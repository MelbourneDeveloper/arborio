import 'package:flutter/material.dart';

///The callback for building the expander or the content of the expander
typedef ExpanderBuilder = Widget Function(
  BuildContext context,
  bool isExpanded,
  Animation<double> animation,
);

///The callback for building the header of the expander
typedef HeaderBuilder = Widget Function(
  BuildContext context,
  VoidCallback onTap,
  Widget? leading,
  Widget title,
);

///Basic animated expander widget that can be used to expand/collapse a list of items
class Expander<T> extends StatefulWidget {
  ///Creates an expander widget
  const Expander({
    required this.contentBuilder,
    required this.children,
    required this.onExpansionChanged,
    required this.isExpanded,
    required this.expanderBuilder,
    this.canExpand = true,
    this.headerBuilder,
    super.key,
    this.animationCurve = Curves.easeInOut,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  ///The children for this expander
  final List<Widget> children;

  ///Called when the expander is expanded or collapsed
  final ValueChanged<bool> onExpansionChanged;

  ///The state of the expander
  final ValueNotifier<bool> isExpanded;

  ///Whether or not the expander can be expanded (has an expander icon)
  final bool canExpand;

  ///The builder for the expander icon (usually an arrow icon or similar)
  final ExpanderBuilder expanderBuilder;

  ///The builder for the content of the expander (usually icon and text)
  final ExpanderBuilder contentBuilder;

  ///Optional builder for custom header implementation. If not provided,
  /// defaults to ListTile
  final HeaderBuilder? headerBuilder;

  ///This modulates the animation for the expander when it opens and closes
  final Curve animationCurve;

  ///The duration of the animation for the expander when it opens and closes
  final Duration animationDuration;

  @override
  State<Expander<T>> createState() => _ExpanderState();
}

class _ExpanderState<T> extends State<Expander<T>>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  ///The rotation animation (I think 0-0.25)
  late Animation<double> _expanderAnimation;

  ///The full animation (I think 0-1?)
  late Animation<double> _contentAnimation;

  late ValueNotifier<bool> isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isExpanded;
    _init();
  }

  @override
  void didUpdateWidget(Expander<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initAnimations();

    isExpanded
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
    isExpanded.addListener(_animate);
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
          widget.headerBuilder?.call(
                context,
                _handleTap,
                widget.canExpand
                    ? widget.expanderBuilder(
                        context,
                        widget.isExpanded.value,
                        _expanderAnimation,
                      )
                    : null,
                widget.contentBuilder(
                  context,
                  widget.isExpanded.value,
                  _contentAnimation,
                ),
              ) ??
              ListTile(
                onTap: _handleTap,
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
