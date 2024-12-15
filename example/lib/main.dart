// ignore_for_file: public_member_api_docs

import 'dart:ui';

import 'package:arborio/tree_view.dart';
import 'package:arborio_sample/data.dart';
import 'package:arborio_sample/functions.dart';
import 'package:arborio_sample/image_builder.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

// The main app widget
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final treeViewKey = const TreeViewKey<FileSystemElement>();
  String _selectedCurve = 'easeInOut';
  Widget _expando = defaultExpander;
  Widget createExpander() =>
      _displayStyle == DisplayStyle.retro ? const SizedBox.shrink() : _expando;
  int _animationDuration = 500;
  final textEditingController = TextEditingController(text: '500');
  TreeNode<FileSystemElement>? _selectedNode;
  final List<TreeNode<FileSystemElement>> _fileTree = fileTree();
  DisplayStyle _displayStyle = DisplayStyle.crazy;

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF44AD4D)),
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFFFEFCE5),
          appBar: PreferredSize(
            preferredSize: const Size(
              double.infinity,
              56,
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: AppBar(
                  backgroundColor: Colors.black.withValues(alpha: 0.2),
                  title: Text(_title()),
                  elevation: 3,
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              // Background image
              Opacity(
                opacity: .025,
                child: imageAsset(
                  'assets/images/arborio_transparent.png',
                  fit: BoxFit.scaleDown,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              // Tree view
              _treeView(),
              // Bottom pane
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _bottomPane(),
              ),
            ],
          ),
        ),
      );

  /// The bottom pane with the duration field, dropdowns, buttons, and style
  ClipRRect _bottomPane() => ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 90,
            color: Colors.black.withValues(alpha: 0.1),
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  _styleToggle(),
                  const SizedBox(width: 16),
                  _durationField(),
                  const SizedBox(width: 16),
                  _dropDownsRow(),
                  const SizedBox(width: 16),
                  _buttonRow(),
                ],
              ),
            ),
          ),
        ),
      );

  /// The duration field for setting the animation duration
  Widget _durationField() => Center(
        child: SizedBox(
          width: 200,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              labelText: 'Animation Duration (ms)',
            ),
            onChanged: (v) {
              setState(() {
                _animationDuration = int.tryParse(v) ?? 500;
              });
            },
            controller: textEditingController,
          ),
        ),
      );

  /// The title of the app
  String _title() => 'Arborio Sample${_selectedNode != null ? ' - '
      '${_selectedNode!.data.name}' : ''}';

  /// The row with the dropdowns for the expander and animation curve
  Widget _dropDownsRow() => Row(
        children: [
          DropdownMenu<Widget>(
            label: const Text('Expander'),
            onSelected: (v) => setState(() => _expando = v ?? _expando),
            initialSelection: _expando,
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: fingerPointer, label: '👉'),
              DropdownMenuEntry(
                value: defaultExpander,
                label: 'Chevron Right Icon',
              ),
              DropdownMenuEntry(
                value: arrowRight,
                label: 'Arrow Right',
              ),
              DropdownMenuEntry(
                value: doubleArrow,
                label: 'Double Arrow',
              ),
            ],
          ),
          const SizedBox(width: 16),
          _curveDropDown(),
        ],
      );

  /// The dropdown for selecting the animation curve
  DropdownMenu<String> _curveDropDown() => DropdownMenu<String>(
        label: const Text('Animation Curve'),
        onSelected: (v) => _selectedCurve = v ?? _selectedCurve,
        initialSelection: _selectedCurve,
        dropdownMenuEntries: const [
          DropdownMenuEntry(value: 'bounceIn', label: 'bounceIn'),
          DropdownMenuEntry(value: 'bounceInOut', label: 'bounceInOut'),
          DropdownMenuEntry(value: 'bounceOut', label: 'bounceOut'),
          DropdownMenuEntry(value: 'ease', label: 'ease'),
          DropdownMenuEntry(value: 'easeIn', label: 'easeIn'),
          DropdownMenuEntry(value: 'easeInBack', label: 'easeInBack'),
          DropdownMenuEntry(value: 'easeInCirc', label: 'easeInCirc'),
          DropdownMenuEntry(value: 'easeInExpo', label: 'easeInExpo'),
          DropdownMenuEntry(value: 'easeInOut', label: 'easeInOut'),
          DropdownMenuEntry(
            value: 'easeInOutBack',
            label: 'easeInOutBack',
          ),
          DropdownMenuEntry(
            value: 'easeInOutCirc',
            label: 'easeInOutCirc',
          ),
          DropdownMenuEntry(
            value: 'easeInOutExpo',
            label: 'easeInOutExpo',
          ),
          DropdownMenuEntry(
            value: 'easeInOutQuad',
            label: 'easeInOutQuad',
          ),
          DropdownMenuEntry(
            value: 'easeInOutQuart',
            label: 'easeInOutQuart',
          ),
          DropdownMenuEntry(
            value: 'easeInOutQuint',
            label: 'easeInOutQuint',
          ),
          DropdownMenuEntry(
            value: 'easeInOutSine',
            label: 'easeInOutSine',
          ),
          DropdownMenuEntry(value: 'easeInQuad', label: 'easeInQuad'),
          DropdownMenuEntry(value: 'easeInQuart', label: 'easeInQuart'),
          DropdownMenuEntry(value: 'easeInQuint', label: 'easeInQuint'),
          DropdownMenuEntry(value: 'easeInSine', label: 'easeInSine'),
          DropdownMenuEntry(value: 'easeOut', label: 'easeOut'),
          DropdownMenuEntry(value: 'easeOutBack', label: 'easeOutBack'),
          DropdownMenuEntry(value: 'easeOutCirc', label: 'easeOutCirc'),
          DropdownMenuEntry(value: 'easeOutExpo', label: 'easeOutExpo'),
          DropdownMenuEntry(value: 'easeOutQuad', label: 'easeOutQuad'),
          DropdownMenuEntry(value: 'easeOutQuart', label: 'easeOutQuart'),
          DropdownMenuEntry(value: 'easeOutQuint', label: 'easeOutQuint'),
          DropdownMenuEntry(value: 'easeOutSine', label: 'easeOutSine'),
          DropdownMenuEntry(value: 'elasticIn', label: 'elasticIn'),
          DropdownMenuEntry(value: 'elasticInOut', label: 'elasticInOut'),
          DropdownMenuEntry(value: 'elasticOut', label: 'elasticOut'),
          DropdownMenuEntry(value: 'linear', label: 'linear'),
        ],
      );

  /// The row with the buttons for adding, expanding, and collapsing
  Row _buttonRow() => Row(
        children: [
          FloatingActionButton(
            tooltip: 'Add',
            onPressed: () => setState(
              () => _fileTree.add(
                TreeNode(
                  const Key('newnode'),
                  FileSystemElement(
                    'New Folder',
                    ElementType.folder,
                  ),
                ),
              ),
            ),
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            tooltip: 'Expand All',
            onPressed: () =>
                setState(() => treeViewKey.currentState!.expandAll()),
            child: const Icon(Icons.expand),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            tooltip: 'Collapse All',
            onPressed: () =>
                setState(() => treeViewKey.currentState!.collapseAll()),
            child: const Icon(Icons.compress),
          ),
        ],
      );

  /// The segmented button for toggling the display style
  Widget _styleToggle() => SegmentedButton<DisplayStyle>(
        segments: const [
          ButtonSegment(
            value: DisplayStyle.crazy,
            label: Text('Crazy'),
            icon: Icon(Icons.style),
          ),
          ButtonSegment(
            value: DisplayStyle.modern,
            label: Text('Modern'),
            icon: Icon(Icons.style),
          ),
          ButtonSegment(
            value: DisplayStyle.retro,
            label: Text('Retro'),
            icon: Icon(Icons.terminal),
          ),
        ],
        selected: {_displayStyle},
        onSelectionChanged: (newSelection) {
          setState(() {
            _displayStyle = newSelection.first;
          });
        },
      );

  /// The tree view widget
  TreeView<FileSystemElement> _treeView() => TreeView(
        nodeContentPadding: switch (_displayStyle) {
          DisplayStyle.crazy => null,
          DisplayStyle.retro => const EdgeInsets.symmetric(vertical: 4),
          _ => EdgeInsets.zero
        },
        onSelectionChanged: (node) => setState(() => _selectedNode = node),
        key: treeViewKey,
        animationDuration: Duration(milliseconds: _animationDuration),
        animationCurve: getAnimationCurve(_selectedCurve),
        builder: (
          context,
          node,
          isSelected,
          expansionAnimation,
          select,
        ) =>
            Align(
          alignment: Alignment.centerLeft,
          child: switch (node.data.type) {
            (ElementType.file) => _file(select, node, isSelected, context),
            (ElementType.folder) => _folder(expansionAnimation, node),
          },
        ),
        nodes: _fileTree,
        expanderBuilder: (context, node, animationValue) =>
            _displayStyle == DisplayStyle.crazy
                ? RotationTransition(
                    turns: animationValue,
                    child: createExpander(),
                  )
                : createExpander(),
        minNodeHeight: _displayStyle == DisplayStyle.retro ? 0 : null,
        minNodeVerticalPadding: _displayStyle == DisplayStyle.retro ? 0 : null,
      );

  /// Renders file nodes with different styles based on the selected display
  /// style
  Widget _file(
    void Function(TreeNode<FileSystemElement> node) select,
    TreeNode<FileSystemElement> node,
    bool isSelected,
    BuildContext context,
  ) =>
      switch (_displayStyle) {
        DisplayStyle.modern => _modernFile(select, node, isSelected, context),
        DisplayStyle.retro => _retroFile(select, node, isSelected, context),
        DisplayStyle.crazy => _crazyFile(select, node, isSelected, context),
      };

  /// The modern file node
  Widget _modernFile(
    void Function(TreeNode<FileSystemElement> node) select,
    TreeNode<FileSystemElement> node,
    bool isSelected,
    BuildContext context,
  ) =>
      InkWell(
        onTap: () => select(node),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.3),
                      Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    switch (path.extension(node.data.name).toLowerCase()) {
                      ('.mp3') => Icons.music_note,
                      ('.py') => Icons.code,
                      ('.jpg' || '.png') => Icons.image,
                      ('.dart') => Icons.flutter_dash,
                      ('.json') => Icons.data_object,
                      _ => Icons.insert_drive_file,
                    },
                    color: Theme.of(context).colorScheme.primary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        node.data.name,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 14,
                                ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'File Type: '
                        '${path.extension(node.data.name).toUpperCase()}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  /// The retro file node
  Widget _retroFile(
    void Function(TreeNode<FileSystemElement> node) select,
    TreeNode<FileSystemElement> node,
    bool isSelected,
    BuildContext context,
  ) =>
      SizedBox(
        height: 24,
        child: InkWell(
          onTap: () => select(node),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.fromLTRB(42, 0, 0, 0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green.withValues(alpha: 0.2) : null,
                border: Border.all(
                  color: Colors.green.withValues(alpha: 0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      switch (path.extension(node.data.name).toLowerCase()) {
                        ('.mp3') => '♪',
                        ('.py') => r'$',
                        ('.jpg' || '.png') => '⚡',
                        ('.dart') => '⚔',
                        ('.json') => '{}',
                        _ => '>'
                      },
                      style: const TextStyle(
                        color: Colors.green,
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        node.data.name,
                        style: const TextStyle(
                          color: Colors.green,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  /// Renders folder nodes with different styles based on the selected display
  /// style
  Widget _folder(
    Animation<double> expansionAnimation,
    TreeNode<FileSystemElement> node,
  ) =>
      switch (_displayStyle) {
        DisplayStyle.modern => _modernFolder(expansionAnimation, node),
        DisplayStyle.retro => _retroFolder(expansionAnimation, node),
        DisplayStyle.crazy => _crazyfolder(expansionAnimation, node),
      };

  /// Renders file nodes
  Widget _crazyFile(
    void Function(TreeNode<FileSystemElement> node) select,
    TreeNode<FileSystemElement> node,
    bool isSelected,
    BuildContext context,
  ) =>
      InkWell(
        onTap: () => select(node),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.3),
                      Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                imageAsset(
                  switch (path.extension(node.data.name).toLowerCase()) {
                    ('.mp3') => 'assets/images/music.png',
                    ('.py') => 'assets/images/python.png',
                    ('.jpg') => 'assets/images/image.png',
                    ('.png') => 'assets/images/image.png',
                    ('.dart') => 'assets/images/dart.png',
                    ('.json') => 'assets/images/json.png',
                    (_) => 'assets/images/file.png'
                  },
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    node.data.name,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  /// Renders tree nodes
  Row _crazyfolder(
    Animation<double> expansionAnimation,
    TreeNode<FileSystemElement> node,
  ) =>
      Row(
        children: [
          RotationTransition(
            turns: expansionAnimation,
            child: imageAsset(
              'assets/images/folder.png',
              width: 32,
              height: 32,
            ),
          ),
          const SizedBox(width: 16),
          Text(node.data.name),
        ],
      );

  /// The modern folder node
  Widget _modernFolder(
    Animation<double> expansionAnimation,
    TreeNode<FileSystemElement> node,
  ) =>
      Container(
        margin: EdgeInsets.zero,
        constraints: const BoxConstraints(maxWidth: 400),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.folder,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  node.data.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Directory',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      );

  /// The retro folder node
  Widget _retroFolder(
    Animation<double> expansionAnimation,
    TreeNode<FileSystemElement> node,
  ) =>
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green.withValues(alpha: 0.5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '▶',
                  style: TextStyle(
                    color: Colors.green,
                    fontFamily: 'monospace',
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    '[${node.data.name}]',
                    style: const TextStyle(
                      color: Colors.green,
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
