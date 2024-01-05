// ignore_for_file: public_member_api_docs

import 'package:arborio/expander.dart';
import 'package:flutter/material.dart';

class TreeViewKey<T> extends GlobalKey<_TreeViewState<T>> {
  const TreeViewKey() : super.constructor();
}

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
  TreeNode(
    this.key,
    this.data, [
    List<TreeNode<T>>? children,
    bool isExpanded = false,
  ])  : children = children ?? <TreeNode<T>>[],
        isExpanded = ValueNotifier(isExpanded);
  final Key key;
  final T data;
  final List<TreeNode<T>> children;
  ValueNotifier<bool> isExpanded;
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

  @override
  void initState() {
    super.initState();
    _selectedNode = widget.selectedNode;
    widget.nodes.forEach(listen);
  }

  void listen(TreeNode<T> node) {
    node.children.forEach(listen);
    node.isExpanded.addListener(() {
      // ignore: avoid_print
      print('asd');
      setState(() {});
    });
  }

  void collapseAll() => setState(() {
        for (final node in widget.nodes) {
          _setIsExpanded(node, false);
        }
      });

  void expandAll() => setState(() {
        for (final node in widget.nodes) {
          _setIsExpanded(node, true);
        }
      });

  void _setIsExpanded(TreeNode<T> node, bool isExpanded) {
    for (final n in node.children) {
      _setIsExpanded(n, isExpanded);
    }

    node.isExpanded.value = isExpanded;
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
                    node.isExpanded.value = expanded;
                  });
                  expansionChanged(node, expanded);
                },
                isExpanded: node.isExpanded.value,
                children: node.children
                    .map((childNode) => _buildNode(childNode, expansionChanged))
                    .toList(),
              ),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    for (final node in widget.nodes) {
      for (final childNode in node.children) {
        childNode.isExpanded.dispose();
      }
      node.isExpanded.dispose();
    }
    super.dispose();
  }
}
