// ignore_for_file: public_member_api_docs

import 'package:arbor/expander.dart';
import 'package:flutter/material.dart';

typedef TreeViewItemBuilder<T> = Widget Function(
  BuildContext context,
  TreeNode<T> node,
  bool isSelected,
  Animation<double> expansionAnimation,
  void Function(TreeNode<T> node) select,
);

typedef ExpansionChanged<T> = void Function(TreeNode<T> node, bool expanded);

void _defaultExpansionChanged<T>(TreeNode<T> node, bool expanded) {}
void _defaultSelectionChanged<T>(TreeNode<T> node) {}

class TreeNode<T> {
  TreeNode(this.key, this.title, [List<TreeNode<T>>? children])
      : children = children ?? <TreeNode<T>>[];
  final Key key;
  final T title;
  final List<TreeNode<T>> children;
}

class TreeView<T> extends StatefulWidget {
  const TreeView({
    required this.nodes,
    required this.builder,
    ExpansionChanged<T>? onExpansionChanged,
    ValueChanged<TreeNode<T>>? onSelectionChanged,
    this.selectedNode,
    this.indentation = const SizedBox(width: 16),
    super.key,
    this.animationCurve = Curves.easeInOut,
    this.expanderIcon,
    this.animationDuration = const Duration(milliseconds: 500),
  })  : onExpansionChanged = onExpansionChanged ?? _defaultExpansionChanged,
        onSelectionChanged = onSelectionChanged ?? _defaultSelectionChanged;

  final List<TreeNode<T>> nodes;
  final ExpansionChanged<T> onExpansionChanged;
  final ValueChanged<TreeNode<T>> onSelectionChanged;
  final TreeNode<T>? selectedNode;
  final Widget indentation;
  final Widget? expanderIcon;
  final TreeViewItemBuilder<T> builder;
  final Curve animationCurve;
  final Duration animationDuration;

  @override
  State<TreeView<T>> createState() => _TreeViewState<T>();
}

class _TreeViewState<T> extends State<TreeView<T>> {
  TreeNode<T>? _selectedNode;
  final Map<Key, bool> _expandedState = {};

  @override
  void initState() {
    super.initState();
    _selectedNode = widget.selectedNode;
  }

  void _handleSelection(TreeNode<T> node) {
    setState(() {
      _selectedNode = node;
    });
    widget.onSelectionChanged(node);
  }

  @override
  Widget build(BuildContext context) => ListView(
        children: widget.nodes
            .map((node) => _buildNode(node, widget.onExpansionChanged))
            .toList(),
      );

  Widget _buildNode(
    TreeNode<T> node,
    ExpansionChanged<T> expansionChanged,
  ) =>
      Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Row(
          children: [
            widget.indentation,
            Expanded(
              child: Expander<T>(
                animationDuration: widget.animationDuration,
                animationCurve: widget.animationCurve,
                expanderIcon: widget.expanderIcon,
                canExpand: node.children.isNotEmpty,
                key: PageStorageKey<Key>(node.key),
                builder: (context, isExpanded, animationValue) =>
                    widget.builder(
                  context,
                  node,
                  _selectedNode?.key == node.key,
                  animationValue,
                  _handleSelection,
                ),
                onExpansionChanged: (expanded) {
                  setState(() {
                    _expandedState[node.key] = expanded;
                  });
                  expansionChanged(node, expanded);
                },
                isExpanded: _expandedState[node.key] ?? false,
                children: node.children
                    .map((childNode) => _buildNode(childNode, expansionChanged))
                    .toList(),
              ),
            ),
          ],
        ),
      );
}
