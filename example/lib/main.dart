// ignore_for_file: public_member_api_docs

import 'dart:ui';

import 'package:arborio/tree_view.dart';
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
                child: Image.asset(
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

  TreeView<FileSystemElement> _treeView() => TreeView(
        onSelectionChanged: (node) => setState(() => _selectedNode = node),
        key: treeViewKey,
        animationDuration: Duration(milliseconds: _animationDuration),
        animationCurve: switch (_selectedCurve) {
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
        },
        builder: (
          context,
          node,
          isSelected,
          expansionAnimation,
          select,
        ) =>
            switch (node.data.type) {
          (ElementType.file) => InkWell(
              onTap: () => select(node),
              // ignore: use_decorated_box
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
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
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Image.asset(
                        switch (path.extension(node.data.name).toLowerCase()) {
                          ('.mp3') => 'assets/images/music.png',
                          ('.py') => 'assets/images/python.png',
                          ('.jpg') => 'assets/images/image.png',
                          ('.png') => 'assets/images/image.png',
                          ('.dart') => 'assets/images/dart.png',
                          ('.json') => 'assets/images/json.png',
                          (_) => 'assets/images/file.png'
                        },
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(width: 16),
                      Text(node.data.name),
                    ],
                  ),
                ),
              ),
            ),
          (ElementType.folder) => Row(
              children: [
                RotationTransition(
                  turns: expansionAnimation,
                  child: Image.asset(
                    'assets/images/folder.png',
                    width: 32,
                    height: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Text(node.data.name),
              ],
            ),
        },
        nodes: _fileTree,
        expanderBuilder: (context, node, animationValue) => RotationTransition(
          turns: animationValue,
          child: _expander,
        ),
      );
}
