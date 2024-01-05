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
  AnimationController? _controller;
  late Animation<double> _iconAnimation;
  late Animation<double> _sizeFactor;
  late ValueNotifier<bool> isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isExpanded;
    initAnimation();
  }

  @override
  void didUpdateWidget(Expander<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    isExpanded = widget.isExpanded;
    initAnimation();
  }

  void initAnimation() {
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    isExpanded.addListener(_animate);
    _iconAnimation = Tween<double>(begin: 0, end: 0.25).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: widget.animationCurve,
      ),
    );
    _sizeFactor = CurvedAnimation(
      parent: _controller!,
      curve: widget.animationCurve,
    );

    if (widget.isExpanded.value) {
      _controller!.value = 1.0;
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.isExpanded.removeListener(_animate);
    _controller?.dispose();
    _controller = null;
  }

  void _handleTap() {
    widget.onExpansionChanged(!widget.isExpanded.value);
    setState(_animate);
  }

  void _animate() {
    if (widget.isExpanded.value) {
      _controller?.reverse();
    } else {
      _controller?.forward();
    }
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
