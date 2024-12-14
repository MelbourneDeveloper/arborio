// ignore_for_file: public_member_api_docs

import 'dart:ui';

import 'package:arborio/tree_view.dart';
import 'package:arborio_sample/image_builder.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

enum ElementType { file, folder }

class FileSystemElement {
  FileSystemElement(this.name, this.type);

  final String name;
  final ElementType type;
}

// Initialize your tree nodes with FileSystemElement type
List<TreeNode<FileSystemElement>> fileTree() => [
      TreeNode<FileSystemElement>(
        const Key('Projects'),
        FileSystemElement('Projects', ElementType.folder),
        [
          TreeNode<FileSystemElement>(
            const Key('FlutterApp'),
            FileSystemElement('FlutterApp', ElementType.folder),
            [
              TreeNode<FileSystemElement>(
                const Key('lib'),
                FileSystemElement('lib', ElementType.folder),
                [
                  TreeNode<FileSystemElement>(
                    const Key('main.dart'),
                    FileSystemElement('main.dart', ElementType.file),
                  ),
                  TreeNode<FileSystemElement>(
                    const Key('app.dart'),
                    FileSystemElement('app.dart', ElementType.file),
                  ),
                ],
              ),
              TreeNode<FileSystemElement>(
                const Key('assets'),
                FileSystemElement('assets', ElementType.folder),
                [
                  TreeNode<FileSystemElement>(
                    const Key('logo.png'),
                    FileSystemElement('logo.png', ElementType.file),
                  ),
                  TreeNode<FileSystemElement>(
                    const Key('data.json'),
                    FileSystemElement('data.json', ElementType.file),
                  ),
                ],
              ),
            ],
          ),
          TreeNode<FileSystemElement>(
            const Key('PythonScripts'),
            FileSystemElement('PythonScripts', ElementType.folder),
            [
              TreeNode<FileSystemElement>(
                const Key('script.py'),
                FileSystemElement('script.py', ElementType.file),
              ),
            ],
          ),
        ],
      ),
      TreeNode<FileSystemElement>(
        const Key('Documents'),
        FileSystemElement('Documents', ElementType.folder),
        [
          TreeNode<FileSystemElement>(
            const Key('Resume.docx'),
            FileSystemElement('Resume.docx', ElementType.file),
          ),
          TreeNode<FileSystemElement>(
            const Key('Budget.xlsx'),
            FileSystemElement('Budget.xlsx', ElementType.file),
          ),
        ],
      ),
      TreeNode<FileSystemElement>(
        const Key('Music'),
        FileSystemElement('Music', ElementType.folder),
        [
          TreeNode<FileSystemElement>(
            const Key('Favorites'),
            FileSystemElement('Favorites', ElementType.folder),
            [
              TreeNode<FileSystemElement>(
                const Key('song1.mp3'),
                FileSystemElement('song1.mp3', ElementType.file),
              ),
              TreeNode<FileSystemElement>(
                const Key('song2.mp3'),
                FileSystemElement('song2.mp3', ElementType.file),
              ),
            ],
          ),
        ],
      ),
      TreeNode<FileSystemElement>(
        const Key('Photos'),
        FileSystemElement('Photos', ElementType.folder),
        [
          TreeNode<FileSystemElement>(
            const Key('Vacation'),
            FileSystemElement('Vacation', ElementType.folder),
            [
              TreeNode<FileSystemElement>(
                const Key('image1.jpg'),
                FileSystemElement('image1.jpg', ElementType.file),
              ),
              TreeNode<FileSystemElement>(
                const Key('image2.jpg'),
                FileSystemElement('image2.jpg', ElementType.file),
              ),
            ],
          ),
          TreeNode<FileSystemElement>(
            const Key('Family'),
            FileSystemElement('Family', ElementType.folder),
            [
              TreeNode<FileSystemElement>(
                const Key('photo1.jpg'),
                FileSystemElement('photo1.jpg', ElementType.file),
              ),
            ],
          ),
        ],
      ),
    ];

const defaultExpander = Icon(Icons.chevron_right);

const arrowRight = Icon(Icons.arrow_right);

const doubleArrow = Icon(Icons.double_arrow);

const fingerPointer = Text(
  '👉',
  style: TextStyle(fontSize: 16),
);

enum DisplayStyle { modern, retro }

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
  Widget _expander = defaultExpander;
  int _animationDuration = 500;
  final textEditingController = TextEditingController(text: '500');
  TreeNode<FileSystemElement>? _selectedNode;
  final List<TreeNode<FileSystemElement>> _fileTree = fileTree();
  DisplayStyle _displayStyle = DisplayStyle.modern;

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
              Opacity(
                opacity: .025,
                child: imageAsset(
                  'assets/images/arborio_transparent.png',
                  fit: BoxFit.scaleDown,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              _treeView(),
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
                  _durationField(),
                  const SizedBox(width: 16),
                  _dropDownsRow(),
                  const SizedBox(width: 16),
                  _buttonRow(),
                  const SizedBox(width: 16),
                  _styleToggle(),
                ],
              ),
            ),
          ),
        ),
      );

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

  String _title() => 'Arborio Sample${_selectedNode != null ? ' - '
      '${_selectedNode!.data.name}' : ''}';

  Widget _dropDownsRow() => Row(
        children: [
          DropdownMenu<Widget>(
            label: const Text('Expander'),
            onSelected: (v) => setState(() => _expander = v ?? _expander),
            initialSelection: _expander,
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
          DropdownMenu<String>(
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
          ),
        ],
      );

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

  Widget _styleToggle() => SegmentedButton<DisplayStyle>(
        segments: const [
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

  TreeView<FileSystemElement> _treeView() => TreeView(
        onSelectionChanged: (node) => setState(() => _selectedNode = node),
        key: treeViewKey,
        animationDuration: Duration(milliseconds: _animationDuration),
        animationCurve: _getAnimationCurve(),
        builder: (
          context,
          node,
          isSelected,
          expansionAnimation,
          select,
        ) =>
            switch (node.data.type) {
          (ElementType.file) => _file(select, node, isSelected, context),
          (ElementType.folder) => _folder(expansionAnimation, node),
        },
        nodes: _fileTree,
        expanderBuilder: (context, node, animationValue) => RotationTransition(
          turns: animationValue,
          child: _expander,
        ),
      );

  Curve _getAnimationCurve() => switch (_selectedCurve) {
        ('bounceIn') => Curves.bounceIn,
        ('bounceInOut') => Curves.bounceInOut,
        ('bounceOut') => Curves.bounceOut,
        ('easeInCirc') => Curves.easeInCirc,
        ('easeInOutExpo') => Curves.easeInOutExpo,
        ('elasticInOut') => Curves.elasticInOut,
        ('easeInOut') => Curves.easeInOut,
        ('easeOutCirc') => Curves.easeOutCirc,
        ('elasticOut') => Curves.elasticOut,
        ('elasticIn') => Curves.elasticIn,
        ('easeIn') => Curves.easeIn,
        ('ease') => Curves.ease,
        ('easeInBack') => Curves.easeInBack,
        ('easeOutBack') => Curves.easeOutBack,
        ('easeInOutBack') => Curves.easeInOutBack,
        ('easeInSine') => Curves.easeInSine,
        ('easeOutSine') => Curves.easeOutSine,
        ('easeInOutSine') => Curves.easeInOutSine,
        ('easeInQuad') => Curves.easeInQuad,
        ('easeOutQuad') => Curves.easeOutQuad,
        ('easeInOutQuad') => Curves.easeInOutQuad,
        ('easeInQuart') => Curves.easeInQuart,
        ('easeOutQuart') => Curves.easeOutQuart,
        ('easeInOutQuart') => Curves.easeInOutQuart,
        ('easeInQuint') => Curves.easeInQuint,
        ('easeOutQuint') => Curves.easeOutQuint,
        ('easeInOutQuint') => Curves.easeInOutQuint,
        ('easeInExpo') => Curves.easeInExpo,
        ('easeOutExpo') => Curves.easeOutExpo,
        ('linear') => Curves.linear,
        _ => Curves.easeInOut,
      };

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
      };

  Widget _modernFile(
    void Function(TreeNode<FileSystemElement> node) select,
    TreeNode<FileSystemElement> node,
    bool isSelected,
    BuildContext context,
  ) =>
      InkWell(
        onTap: () => select(node),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha:0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ,]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
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
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        node.data.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'File Type: '
                        '${path.extension(node.data.name).toUpperCase()}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _retroFile(
    void Function(TreeNode<FileSystemElement> node) select,
    TreeNode<FileSystemElement> node,
    bool isSelected,
    BuildContext context,
  ) =>
      InkWell(
        onTap: () => select(node),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green.withValues(alpha: 0.2) : null,
            border: Border.all(
              color: Colors.green.withValues(alpha:  0.5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
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
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  node.data.name,
                  style: const TextStyle(
                    color: Colors.green,
                    fontFamily: 'monospace',
                    fontSize: 14,
                  ),
                ),
              ],
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
      };

  Widget _modernFolder(
    Animation<double> expansionAnimation,
    TreeNode<FileSystemElement> node,
  ) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.withValues(alpha:0.2),
              Colors.purple.withValues(alpha:0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              RotationTransition(
                turns: expansionAnimation,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.folder,
                    color: Colors.blue,
                  ),
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
                  ),
                  Text(
                    'Directory',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _retroFolder(
    Animation<double> expansionAnimation,
    TreeNode<FileSystemElement> node,
  ) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green.withValues(alpha:0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              RotationTransition(
                turns: expansionAnimation,
                child: const Text(
                  '▶',
                  style: TextStyle(
                    color: Colors.green,
                    fontFamily: 'monospace',
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '[${node.data.name}]',
                style: const TextStyle(
                  color: Colors.green,
                  fontFamily: 'monospace',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
}
