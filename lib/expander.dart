import 'package:flutter/material.dart';

typedef ExpanderContentBuilder = Widget Function(
  BuildContext context,
  bool isExpanded,
  Animation<double> animation,
);

class Expander<T> extends StatefulWidget {
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
  });

  final List<Widget> children;
  final ValueChanged<bool> onExpansionChanged;
  final ValueNotifier<bool> isExpanded;
  final bool canExpand;
  final ExpanderContentBuilder expanderBuilder;
  final ExpanderContentBuilder contentBuilder;
  final Curve animationCurve;
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
