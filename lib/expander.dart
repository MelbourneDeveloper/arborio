import 'package:flutter/material.dart';

typedef ExpanderItemBuilder = Widget Function(
  BuildContext context,
  bool isExpanded,
  Animation<double> animationValue,
);

class Expander<T> extends StatefulWidget {
  const Expander({
    required this.builder,
    required this.children,
    required this.onExpansionChanged,
    required this.isExpanded,
    this.canExpand = true,
    super.key,
    this.expanderIcon,
    this.animationCurve = Curves.easeInOut,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  final List<Widget> children;
  final ValueChanged<bool> onExpansionChanged;
  final ValueNotifier<bool> isExpanded;
  final bool canExpand;
  final Widget? expanderIcon;
  final ExpanderItemBuilder builder;
  final Curve animationCurve;
  final Duration animationDuration;

  @override
  State<Expander<T>> createState() => _ExpanderState();
}

class _ExpanderState<T> extends State<Expander<T>>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconAnimation;
  late Animation<double> _sizeFactor;

  @override
  void initState() {
    super.initState();
    initAnimation();

    widget.isExpanded.addListener(() {
      if (!mounted) return;
      if (widget.isExpanded.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void didUpdateWidget(Expander<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    initAnimation();
    // if (oldWidget.isExpanded != widget.isExpanded) {
    //   if (widget.isExpanded.value) {
    //     _controller.forward();
    //   } else {
    //     _controller.reverse();
    //   }
    // }
  }

  void initAnimation() {
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

    if (widget.isExpanded.value) {
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
      if (widget.isExpanded.value) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      widget.onExpansionChanged(!widget.isExpanded.value);
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
              widget.isExpanded.value,
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
