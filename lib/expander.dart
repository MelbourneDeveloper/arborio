import 'package:flutter/material.dart';

typedef ExpanderItemBuilder = Widget Function(
  BuildContext context,
  bool isSelected,
  Animation<double> animationState,
);

class Expander<T> extends StatefulWidget {
  const Expander({
    required this.builder,
    required this.children,
    required this.onExpansionChanged,
    this.canExpand = true,
    this.isExpanded = false,
    super.key,
    this.expanderIcon,
    this.animationCurve = Curves.easeInOut,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  final List<Widget> children;
  final ValueChanged<bool> onExpansionChanged;
  final bool isExpanded;
  final bool canExpand;
  final Widget? expanderIcon;
  final ExpanderItemBuilder builder;
  final Curve animationCurve;
  final Duration animationDuration;

  @override
  State<Expander<T>> createState() => _ExpanderState();
}

class _ExpanderState<T> extends State<Expander<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconAnimation;
  late Animation<double> _sizeFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _iconAnimation = Tween<double>(begin: 0, end: 0.25).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.animationCurve,
      ),
    );
    _sizeFactor = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    );

    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      if (widget.isExpanded) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      widget.onExpansionChanged(!widget.isExpanded);
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            onTap: _handleTap,
            leading: widget.canExpand
                ? RotationTransition(
                    turns: _iconAnimation,
                    child:
                        widget.expanderIcon ?? const Icon(Icons.chevron_right),
                  )
                : null,
            title: widget.builder(
              context,
              widget.isExpanded,
              _sizeFactor,
            ),
          ),
          SizeTransition(
            sizeFactor: _sizeFactor,
            child: Column(children: widget.children),
          ),
        ],
      );
}
