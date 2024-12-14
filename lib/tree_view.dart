// ignore_for_file: lines_longer_than_80_chars

import 'package:arborio/expander.dart';
import 'package:flutter/material.dart';

/// A [GlobalKey] for controlling the state of the [TreeView].
///
/// Example:
/// ```dart
/// final treeKey = TreeViewKey<String>();
/// TreeView<String>(
///   key: treeKey,
///   // ... other parameters
/// )
/// ```
class TreeViewKey<T> extends GlobalKey<_TreeViewState<T>> {
  /// Creates a [GlobalKey] for controlling the state of the [TreeView].
  const TreeViewKey() : super.constructor();
}

/// Callback function for building tree nodes, including animation values.
///
/// Example:
/// ```dart
/// Widget buildNode(BuildContext context, TreeNode<String> node, bool isSelected,
///     Animation<double> expansionAnimation, Function(TreeNode<String>) select) {
///   return Text(node.data);
/// }
/// ```
typedef TreeViewBuilder<T> = Widget Function(
  BuildContext context,
  TreeNode<T> node,
  bool isSelected,
  Animation<double> expansionAnimation,
  void Function(TreeNode<T> node) select,
);

/// Callback function when a node expands or collapses.
///
/// Example:
/// ```dart
/// void onExpand(TreeNode<String> node, bool expanded) {
///   print('Node ${node.data} is now ${expanded ? 'expanded' : 'collapsed'}');
/// }
/// ```
typedef ExpansionChanged<T> = void Function(TreeNode<T> node, bool expanded);

void _defaultExpansionChanged<T>(TreeNode<T> node, bool expanded) {}
void _defaultSelectionChanged<T>(TreeNode<T> node) {}

/// Represents a node in the [TreeView] hierarchy.
///
/// Example:
/// ```dart
/// final node = TreeNode<String>(
///   ValueKey('root'),
///   'Root Node',
///   [
///     TreeNode<String>(ValueKey('child1'), 'Child 1'),
///     TreeNode<String>(ValueKey('child2'), 'Child 2'),
///   ],
///   true, // initially expanded
/// );
/// ```
class TreeNode<T> {
  /// Creates a tree node with the specified [key], [data], optional [children],
  /// and initial expansion state.
  TreeNode(
    this.key,
    this.data, [
    List<TreeNode<T>>? children,
    bool isExpanded = false,
  ])  : children = children ?? <TreeNode<T>>[],
        _isExpanded = ValueNotifier(isExpanded);

  /// The unique key for this node.
  final Key key;

  /// The data associated with this node.
  final T data;

  /// The child nodes of this node.
  final List<TreeNode<T>> children;

  /// Controls the expansion state of this node.
  /// When modified, the node's expander will animate open or closed.
  final ValueNotifier<bool> _isExpanded;

  /// Gets the current expansion state of the node.
  ValueNotifier<bool> get isExpanded => _isExpanded;
}

/// A hierarchical tree view widget for displaying data in a collapsible structure.
///
/// Example:
/// ```dart
/// TreeView<String>(
///   nodes: [
///     TreeNode<String>(ValueKey('root'), 'Root'),
///   ],
///   builder: (context, node, isSelected, animation, select) {
///     return Text(node.data);
///   },
///   expanderBuilder: (context, isExpanded, animation) {
///     return Icon(isExpanded ? Icons.expand_more : Icons.chevron_right);
///   },
/// )
/// ```
class TreeView<T> extends StatefulWidget {
  /// Creates a [TreeView] widget with the specified parameters.
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
    this.nodeContentPadding,
    this.animationDuration = const Duration(milliseconds: 500),
  })  : _onExpansionChanged = onExpansionChanged ?? _defaultExpansionChanged,
        _onSelectionChanged = onSelectionChanged ?? _defaultSelectionChanged;

  /// The root nodes of the tree view.
  final List<TreeNode<T>> nodes;

  /// Called when a node's expansion state changes.
  final ExpansionChanged<T> _onExpansionChanged;

  /// Called when the selected node changes.
  final ValueChanged<TreeNode<T>> _onSelectionChanged;

  /// The currently selected node, if any.
  final TreeNode<T>? selectedNode;

  /// Widget used for indentation of child nodes.
  final Widget indentation;

  /// Builds the expander icon (typically an arrow or chevron).
  final ExpanderBuilder expanderBuilder;

  /// Builds the content of each node.
  final TreeViewBuilder<T> builder;

  /// The animation curve for expand/collapse animations.
  final Curve animationCurve;

  /// The duration of expand/collapse animations.
  final Duration animationDuration;

  /// The padding around the content inside the node. The default is 16.0.
  final EdgeInsetsGeometry? nodeContentPadding;

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
    node.isExpanded.addListener(() => setState(() {}));
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
    widget._onSelectionChanged(node);
  }

  @override
  Widget build(BuildContext context) => ListView(
        children: widget.nodes
            .map((node) => _buildNode(node, widget._onExpansionChanged))
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
                contentPadding: widget.nodeContentPadding,
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
