
import 'package:arborio/expander.dart';
import 'package:flutter/material.dart';

///[GlobalKey] for controlling the state of the [TreeView]
class TreeViewKey<T> extends GlobalKey<_TreeViewState<T>> {
  ///Creates a [GlobalKey] for controlling the state of the [TreeView]
  const TreeViewKey() : super.constructor();
}

///The callback function for building tree nodes, including animation values
typedef TreeViewBuilder<T> = Widget Function(
  BuildContext context,
  TreeNode<T> node,
  bool isSelected,
  Animation<double> expansionAnimation,
  void Function(TreeNode<T> node) select,
);

///The callback function when the node expands or collapses
typedef ExpansionChanged<T> = void Function(TreeNode<T> node, bool expanded);

void _defaultExpansionChanged<T>(TreeNode<T> node, bool expanded) {}
void _defaultSelectionChanged<T>(TreeNode<T> node) {}

///Represents a tree node in the [TreeView]
class TreeNode<T> {
  ///Creates a tree node
  TreeNode(
    this.key,
    this.data, [
    List<TreeNode<T>>? children,
    bool isExpanded = false,
  ])  : children = children ?? <TreeNode<T>>[],
        isExpanded = ValueNotifier(isExpanded);
  ///The unique key for this node
  final Key key;
  ///The data for this node
  final T data;
  ///The children of this node
  final List<TreeNode<T>> children;
  ///Whether or not this node is expanded. Changing this value will cause the
  ///node's expander to animate open or closed
  ValueNotifier<bool> isExpanded;
}

///A tree view widget that for displaying data hierarchically
class TreeView<T> extends StatefulWidget {
  ///Creates a [TreeView] widget
  const TreeView({
    required this.nodes,
    required this.builder,
    required this.expanderBuilder,
    ExpansionChanged<T>? onExpansionChanged,
    ValueChanged<TreeNode<T>>? onSelectionChanged,
    this.selectedNode,
    this.indentation = const SizedBox(width: 16),
    super.key,
    this.animationCurve = Curves.easeInOut,
    this.animationDuration = const Duration(milliseconds: 500),
  })  : onExpansionChanged = onExpansionChanged ?? _defaultExpansionChanged,
        onSelectionChanged = onSelectionChanged ?? _defaultSelectionChanged;

  ///The root nodes for this tree view, which can have children
  final List<TreeNode<T>> nodes;

  ///Called when a node is expanded or collapsed
  final ExpansionChanged<T> onExpansionChanged;

  ///Called when the selected node changes
  final ValueChanged<TreeNode<T>> onSelectionChanged;

  ///The currently selected node
  final TreeNode<T>? selectedNode;

  ///The widget to use for indentation of nodes
  final Widget indentation;

  ///The builder for the expander icon (usually an arrow icon or similar)
  final ExpanderBuilder expanderBuilder;

  ///The builder for the content of the expander (usually icon and text)
  final TreeViewBuilder<T> builder;

  ///This modulates the animation for the expander when it opens and closes
  final Curve animationCurve;

  ///The duration of the animation for the expander when it opens and closes
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
    widget.nodes.forEach(_listen);
  }

  void _listen(TreeNode<T> node) {
    node.children.forEach(_listen);
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
                expanderBuilder: widget.expanderBuilder,
                canExpand: node.children.isNotEmpty,
                key: PageStorageKey<Key>(node.key),
                contentBuilder: (context, isExpanded, animationValue) =>
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
                isExpanded: node.isExpanded,
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
